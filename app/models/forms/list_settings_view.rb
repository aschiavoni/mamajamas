class Forms::ListSettingsView
  # ActiveModel plumbing for form_for
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations
  extend ActiveModel::Translation

  def persisted?
    false
  end

  # app code
  delegate :has_list?, to: :user
  delegate :private?, :public?, :registered_users_only?, :registry?, to: :list
  delegate :privacy, :privacy=, to: :list

  def initialize(user)
    @user = user
    @list = user.list
  end

  def update!(attributes = {})
    update_attributes(attributes)
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
    list.save!
  rescue
    false
  end

  def user
    @user
  end

  def list
    @list
  end
end
