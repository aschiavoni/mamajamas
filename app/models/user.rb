class User < ActiveRecord::Base
  extend FriendlyId
  friendly_id :username, use: [ :slugged, :history ]

  include GoingPostal

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable,
    :rememberable, :trackable, :validatable, :omniauthable

  # cache facebook friends in the database
  serialize :facebook_friends, Array

  # Virtual attribute for authenticating by either username or email
  attr_accessor :login

  # Setup accessible (or protected) attributes for your model
  attr_accessible :username, :email, :password, :password_confirmation, :remember_me
  attr_accessible :login, :provider, :uid, :access_token, :access_token_expires_at
  attr_accessible :first_name, :last_name, :birthday
  attr_accessible :facebook_friends, :facebook_friends_updated_at
  attr_accessible :relationships_created_at
  attr_accessible :zip_code, :country_code
  attr_accessible :welcome_sent_at

  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :reverse_relationships, foreign_key: "followed_id", class_name: "Relationship", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed
  has_many :followers, through: :reverse_relationships, source: :follower
  has_many :product_types, dependent: :destroy
  has_one :list, dependent: :destroy
  has_many :kids, dependent: :destroy
  has_many :list_item_images, dependent: :destroy

  mount_uploader :profile_picture, ProfilePictureUploader

  validates(:username, presence: true, reserved_name: true,
            uniqueness: true, format: { :with => /^[A-Za-z\d_]+$/ })
  validate :valid_zip_code
  validate :valid_country_code

  before_validation :set_username

  scope :guests, lambda { where(guest: true) }
  scope :registered, lambda { where(guest: false) }
  scope :admins, lambda { where(admin: true) }
  scope :facebook, lambda {
    registered.where(provider: "facebook").where("uid IS NOT NULL")
  }

  # hook devise to support logging in by email or username
  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end

  # hook devise to login a facebook user from the session
  # TODO: verify that this is actually used
  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
        user.username = data["username"] if user.username.blank?
      end
    end
  end

  def self.new_guest
    guest_username = "guest_#{Time.now.to_i}#{rand(99)}"
    create do |u|
      u.email = "#{guest_username}@mamajamas-guest.com"
      u.guest = true
    end
  end

  def valid_zip_code
    if zip_code.present?
      unless zip_code_valid?
        emsg = I18n.t 'activerecord.errors.models.user.attributes.zip_code.invalid'
        errors.add(:zip_code, emsg)
      end
    end
  end

  def valid_country_code
    if country_code.present?
      emsg = I18n.t 'activerecord.errors.models.user.attributes.country_code.invalid'
      errors.add(:country_code, emsg) unless Country[country_code]
    end
  end

  def display_email
    guest? ? 'Guest' : email
  end

  def country_name
    country = Country[country_code]
    country.present? ? country.name : nil
  end

  def set_username
    if email.present? && username.blank?
      self.username = UsernameGenerator.from_email(email)
    end
  end

  # prompt for confirmation but don't require it
  def confirmation_required?
    !guest?
  end

  def add_facebook_uid!(uid)
    self.provider = "facebook"
    self.uid = uid
    save!
  end

  def facebook_connected?
    provider == "facebook" && uid.present?
  end

  def facebook
    @facebook ||= FacebookGraph.new(self)
  end

  def following?(other_user)
    relationships.find_by_followed_id(other_user.id)
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    relationships.find_by_followed_id(other_user.id).destroy
  end

  def auto_created_relationships?
    relationships_created_at.present?
  end

  def has_list?
    list.present?
  end

  def build_list!
    kid = self.kids.order('created_at ASC').first
    ListBuilder.new(self, kid).build! if list.blank?
  end

  def reset_list!
    if has_list?
      list.destroy
      build_list!
    end
  end

  def age(now = Time.now.utc.to_date)
    return nil if birthday.blank?
    dob = birthday
    now.year - dob.year - ((now.month > dob.month || (now.month == dob.month && now.day >= dob.day)) ? 0 : 1)
  end

  def send_welcome_email
    unless welcome_sent_at.present?
      UserMailer.welcome(self.id).deliver
      update_attributes!(welcome_sent_at: Time.now.utc)
    end
  end

  protected

  def password_required?
    return false if guest?
    super
  end
end
