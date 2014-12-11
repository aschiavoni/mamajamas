class Forms::SettingsView
  # ActiveModel plumbing for form_for
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations
  extend ActiveModel::Translation

  PREFERENCES = [
                 :followed_user_updates_enabled,
                 :new_follower_notifications_enabled,
                 :blog_updates_enabled,
                 :product_updates_enabled
                ]

  def persisted?
    false
  end

  # app code
  attr_reader :user
  attr_reader :address
  attr_reader :list

  delegate :username, :first_name, :last_name, :email, to: :user
  delegate :username=, :first_name=, :last_name=, :email=, to: :user
  delegate :title, to: :list
  delegate :title=, to: :list
  delegate :private?, :public?, :registered_users_only?, to: :list
  delegate :privacy, :privacy=, to: :list
  delegate :street, :street2, :city, :region, :phone, to: :address
  delegate :street=, :street2=, :city=, :region=, :phone=, to: :address
  delegate :followed_user_updates_enabled, to: :user
  delegate :followed_user_updates_enabled=, to: :user
  delegate :new_follower_notifications_enabled, to: :user
  delegate :new_follower_notifications_enabled=, to: :user
  delegate :blog_updates_enabled, to: :user
  delegate :blog_updates_enabled=, to: :user
  delegate :product_updates_enabled, to: :user
  delegate :product_updates_enabled=, to: :user

  validates(:username, presence: true, format: { :with => /\A[A-Za-z\d_]+\z/ })
  validates(:title, length: { maximum: 45 })

  validate do
    required_objects = [ user, list ]
    required_objects.push(address) if registry || has_partial_address?

    required_objects.each do |object|
      if object.present? && !object.valid?
        object.errors.each do |key, values|
          errors[key] = values
        end
      end
    end
  end

  def initialize(user)
    @user = user
    @list = user.list
    @address = user.address || user.build_address
  end

  def process_atrributes(attributes)
    attrs = attributes.with_indifferent_access

    unsub_all = attrs.delete(:unsubscribe_all)
    if truthy?(unsub_all)
      attrs.merge!(Hash[PREFERENCES.map { |p| [p, false] }])
    else
      PREFERENCES.each do |e|
        if attrs.has_key?(e)
          curval = attrs[e].to_s
          attrs[e] = truthy?(curval)
        end
      end
    end
    attrs
  end

  def baby_due_date
    user.baby_due_date.blank? ? nil : user.baby_due_date.strftime('%m/%d/%Y')
  end

  def partner_first_name
    @partner_first_name ||= user.partner_full_name.split(" ").first
  end

  def partner_last_name
    @partner_last_name ||= (
      parts = user.partner_full_name.split(" ")
      parts.shift
      parts.join(" ")
    )
  end

  def partner_first_name=(fn)
    @partner_first_name = fn
  end

  def partner_last_name=(ln)
    @partner_last_name = ln
  end

  def registry
    list.present? ? list.registry : true
  end

  def registry=(on)
    if list.present?
      list.registry = on
    end
  end

  def address_full_name
    address.full_name.present? ? address.full_name : user.full_name
  end

  def address_full_name=(new_full_name)
    address.full_name = new_full_name
  end

  def countries
    @countries ||= Country.all.sort
  end

  def postal_code
    user.zip_code.blank? ? nil : user.zip_code
  end

  def postal_code=(pc)
    address.postal_code = pc
    user.zip_code = pc
  end

  def country_code
    user.country_code.blank? ? nil : user.country_code
  end

  def country_code=(cc)
    address.country_code = cc
    user.country_code = cc
  end

  def formatted_baby_due_date
    baby_due_date.present? ? I18n.l(baby_due_date) : nil
  end

  def baby_due_date=(new_due_date)
    if new_due_date.is_a?(String) && !new_due_date.empty?
      new_due_date = Date.strptime(new_due_date, I18n.t("date.formats.default"))
    end
    user.baby_due_date = new_due_date
  end

  def has_list?
    list.present?
  end

  def has_partial_address?
    return false if address.blank?
    [ :street, :street2, :city, :region, :phone ].map do |f| 
      address.public_send(f).present?
    end.any?
  end

  def update!(attributes = {})
    attrs = process_atrributes(attributes)
    update_attributes(attrs)
    return false unless valid?
    saved = save
    EmailSubscriptionUpdaterWorker.perform_in(5.minutes, user.id) if saved
    saved
  end

  private

  def update_attributes(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def save
    ActiveRecord::Base.transaction do
      address.street.present? ? user.address = address : user.address = nil

      user.partner_full_name = [
        partner_first_name,
        partner_last_name
      ].join(" ").strip

      user.save!
      list.save! if list.present?
      true
    end
  rescue
    false
  end

  def user
    @user
  end

  def list
    @list
  end

  def address
    @address
  end

  def truthy?(val)
    val == "true" || val == "1"
  end
end
