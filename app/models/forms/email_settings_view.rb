class Forms::EmailSettingsView
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
  delegate :followed_user_updates_enabled, to: :user
  delegate :followed_user_updates_enabled=, to: :user
  delegate :new_follower_notifications_enabled, to: :user
  delegate :new_follower_notifications_enabled=, to: :user
  delegate :blog_updates_enabled, to: :user
  delegate :blog_updates_enabled=, to: :user
  delegate :product_updates_enabled, to: :user
  delegate :product_updates_enabled=, to: :user

  def initialize(user)
    @user = user
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

  def update!(attributes = {})
    attrs = process_atrributes(attributes)
    update_attributes(attrs)
    return false unless valid?
    save
  end

  private

  def update_attributes(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def save
    user.save!
  rescue
    false
  end

  def user
    @user
  end

  def truthy?(val)
    val == "true" || val == "1"
  end
end
