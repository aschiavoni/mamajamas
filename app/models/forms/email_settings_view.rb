class Forms::EmailSettingsView
  # ActiveModel plumbing for form_for
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations
  extend ActiveModel::Translation

  def persisted?
    false
  end

  # app code
  delegate :followed_user_updates_enabled, to: :user
  delegate :followed_user_updates_enabled=, to: :user
  delegate :new_follower_notifications_enabled, to: :user
  delegate :new_follower_notifications_enabled=, to: :user

  def initialize(user)
    @user = user
  end

  def process_atrributes(attributes)
    attrs = attributes.with_indifferent_access

    [
     'followed_user_updates_enabled',
     'new_follower_notifications_enabled'
    ].each do |e|
      if attrs.has_key?(e)
        curval = attrs[e].to_s
        attrs[e] = (curval == "true" || curval == "1")
      end
    end
    attrs
  end

  def update!(attributes = {})
    update_attributes(process_atrributes(attributes))
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
end
