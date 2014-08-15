class Forms::UserProfile
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
  attr_reader :list

  delegate :username, :first_name, :last_name, :birthday, :to => :user
  delegate :username=, :first_name=, :last_name=, :birthday=, :to => :user
  delegate :slug, :to => :user
  delegate :profile_picture, :profile_picture=, :to => :user
  delegate :notes, :notes=, :to => :user
  delegate :profile_picture_cache, :profile_picture_cache=, :to => :user
  delegate :title, :title=, :to => :list, :prefix => true, :allow_nil => true

  validates(:username, presence: true, format: { :with => /\A[A-Za-z\d_]+\z/ })
  validates(:list_title, length: { maximum: 45 })

  validate do
    [user, list].each do |object|
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
  end

  def update!(attributes = {})
    update_attributes(attributes)
    return false unless valid?
    save
  end

  def list_url
    slug
  end

  def formatted_birthday
    birthday.present? ? I18n.l(birthday) : nil
  end

  def birthday=(new_birthday)
    if new_birthday.is_a?(String) && !new_birthday.empty?
      new_birthday = Date.strptime(new_birthday, I18n.t("date.formats.default"))
    end
    user.birthday = new_birthday
  end

  private

  def update_attributes(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def save
    ActiveRecord::Base.transaction do
      user.save!
      list.save!
    end
  rescue
    false
  end

end
