class Forms::CompleteProfile
  # ActiveModel plumbing for form_for
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations
  extend ActiveModel::Translation

  def persisted?
    false
  end

  attr_reader :user

  delegate :email, :email=, :to => :user
  delegate :password, :password=, :to => :user
  delegate :password_confirmation, :password_confirmation=, :to => :user

  validates(:password, presence: true, confirmation: true)

  validate do
    [user].each do |object|
      unless object.valid?
        object.errors.each do |key, values|
          errors[key] = values
        end
      end
    end
  end

  def initialize(user)
    @user = user
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
    ActiveRecord::Base.transaction do
      user.guest = false
      user.save!
    end
  rescue
    user.reload
    false
  end
end
