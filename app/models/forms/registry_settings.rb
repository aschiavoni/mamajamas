class Forms::RegistrySettings
  # ActiveModel plumbing for form_for
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations
  extend ActiveModel::Translation

  def persisted?
    false
  end

  # app code
  attr_reader :user
  attr_reader :address
  attr_reader :list

  delegate(:partner_full_name, :partner_full_name=, to: :user)
  delegate(:full_name=, :street, :street2, :city, :region, :phone,
           to: :address)
  delegate(:street=, :street2=, :city=, :region=, :phone=, to: :address)

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

  def initialize(user, list)
    @user = user
    @list = list
    @address = user.address || user.build_address
  end

  def full_name
    address.full_name.present? ? address.full_name : user.full_name
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

  def registry
    list.present? ? list.registry : true
  end

  def registry=(on)
    if list.present?
      list.registry = on
    end
  end

  def update!(attributes = {})
    update_attributes(attributes)
    return false unless valid?
    save
  end

  def settings_title
    if has_list?
      if user.setup_registry?
        "Registry Details"
      else
        "Gifts will ship to:"
      end
    else
      "Complete Sign Up"
    end
  end

  def settings_button_text
    setup_registry? ? "Update" : "Build Registry"
  end

  def has_list?
    list.present?
  end

  def setup_registry?
    user.setup_registry?
  end

  def has_partial_address?
    return false if address.blank?
    [ :street, :street2, :city, :region, :phone ].map do |f|
      address.public_send(f).present?
    end.any?
  end

  private

  def update_attributes(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def save
    ActiveRecord::Base.transaction do
      if address.street.present?
        user.address = address
      else
        user.address = nil
      end
      user.setup_registry = true
      user.save!
      list.save! if list.present?
      true
    end
  rescue
    false
  end

end
