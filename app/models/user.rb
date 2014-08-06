class User < ActiveRecord::Base
  include EmailPreferences

  extend FriendlyId
  friendly_id :username, use: [ :slugged, :history ]

  include GoingPostal

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable,
    :rememberable, :trackable, :validatable, :omniauthable, :async

  # cache facebook friends in the database
  serialize :facebook_friends, Array

  serialize :email_preferences, ActiveRecord::Coders::Hstore
  serialize :settings, ActiveRecord::Coders::Hstore

  # Virtual attribute for authenticating by either username or email
  attr_accessor :login

  # Setup accessible (or protected) attributes for your model
  attr_accessible :username
  attr_accessible :email
  attr_accessible :password, :password_confirmation
  attr_accessible :remember_me
  attr_accessible :login
  attr_accessible :first_name, :last_name, :birthday
  attr_accessible :facebook_friends, :facebook_friends_updated_at
  attr_accessible :relationships_created_at
  attr_accessible :zip_code, :country_code
  attr_accessible :full_name, :signup_registration
  attr_accessible :welcome_sent_at
  attr_accessible :guest
  attr_accessible :admin_notes
  attr_accessible :show_bookmarklet_prompt

  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :reverse_relationships, foreign_key: "followed_id", class_name: "Relationship", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed
  has_many :followers, through: :reverse_relationships, source: :follower
  has_many :product_types, dependent: :destroy
  has_one :list, dependent: :destroy
  has_many :kids, dependent: :destroy
  has_many :list_item_images, dependent: :destroy
  has_many :quiz_answers, class_name: "Quiz::Answer", dependent: :destroy
  has_many :invites, dependent: :destroy
  has_many :authentications, dependent: :destroy
  has_many :social_friends, dependent: :destroy, class_name: "SocialFriends"

  mount_uploader :profile_picture, ProfilePictureUploader

  validates(:username, presence: true, reserved_name: true,
            length: { minimum: 4 }, uniqueness: true,
            format: { :with => /^[A-Za-z\d_]+$/ })
  validates :full_name, presence: true, if: Proc.new { |u| u.signup_registration? }
  validate :valid_zip_code
  validate :valid_country_code

  before_validation :set_username
  before_validation(on: :create) do
    self.email_preferences = {}
    self.settings = { show_bookmarklet_prompt: true }
  end

  scope :guests, lambda { where(guest: true) }
  scope :registered, lambda { where(guest: false) }
  scope :admins, lambda { where(admin: true) }
  scope :facebook, lambda {
    registered.joins(:authentications).
    where("authentications.provider" => "facebook").
    where("authentications.uid IS NOT NULL")
  }
  scope :google, lambda {
    registered.joins(:authentications).
    where("authentications.provider" => "google").
    where("authentications.uid IS NOT NULL")
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
      u.remember_me = true
      u.guest = true
    end
  end

  def username=(username)
    username = username.downcase if username.present?
    write_attribute(:username, username)
  end

  def full_name
    if first_name.present? && last_name.present?
      "#{first_name} #{last_name}"
    elsif first_name.present?
      "#{first_name}"
    else
      nil
    end
  end

  def full_name=(full_name)
    return if full_name.blank?
    name_parts = full_name.split.reject { |p| p.blank? }
    fname = name_parts.shift
    lname = name_parts.join(" ") if name_parts.size > 0
    self.first_name = fname if fname.present?
    self.last_name = lname if lname.present?
  end

  def signup_registration
    @signup_registration || false
  end

  def signup_registration?
    signup_registration
  end

  def signup_registration=(val)
    @signup_registration = ( val == "true" || val == true )
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
    if username.blank?
      if full_name.present?
        self.username = UsernameGenerator.from_name(full_name)
      elsif email.present?
        self.username = UsernameGenerator.from_email(email)
      end
    end
  end

  # prompt for confirmation but don't require it
  def confirmation_required?
    !guest?
  end

  def clear_facebook!
    authentications.facebook.destroy_all
    self.facebook_friends = nil
    save!
  end

  def facebook_connected?
    auth = authentications.facebook.first
    auth.present? && auth.uid.present?
  end

  def facebook
    @facebook ||= FacebookGraph.new(self, authentications.facebook.first)
  end

  def clear_google!
    authentications.google.destroy_all
    social_friends.google.destroy_all
  end

  def google_connected?
    auth = authentications.google.first
    auth.present? && auth.uid.present? && !auth.access_token_expired?
  end

  def google_friends
    friends = social_friends.google.first
    return [] if friends.blank?
    friends.friends
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

  def has_shared_list?
    has_list? && !list.private?
  end

  def build_list!
    kid = self.kids.order('created_at ASC').first
    ListBuilder.new(self, kid).build! if list.blank?
  end

  def build_custom_list?
    answer = Quiz::Answer.most_recent_answers(self.id).
      select { |a| a.question == "custom list" }.first
    answer.present? && answer.answers.first == "true"
  end

  def reset_list!
    if has_list?
      list.destroy
    end
    reload
    build_list!
    ListQuizUpdater.new(self).update!
    ListPruner.prune!(list)
    list.complete!
  end

  def complete_quiz!
    update_attributes!({ quiz_taken_at: Time.now.utc },
                       { without_protection: true })
  end

  def age(now = Time.now.utc.to_date)
    return nil if birthday.blank?
    dob = birthday
    now.year - dob.year - ((now.month > dob.month || (now.month == dob.month && now.day >= dob.day)) ? 0 : 1)
  end

  def send_welcome_email
    return if guest?
    unless welcome_sent_at.present?
      UserMailer.delay.welcome(self.id)
      update_attributes!(welcome_sent_at: Time.now.utc)
    end
  end

  def parent_status
    quiz_age_answer.present? ? quiz_age_answer.answers.first : "unknown"
  end

  def due_date
    quiz_age_answer.present? ? quiz_age_answer.answers[2] : "n/a"
  end

  def due_date_for_mailing_list
    if quiz_age_answer.present?
      # attempt to format this in a way mailchimp prefers
      d = quiz_age_answer.answers[2]
      Date.strptime(d, '%m/%d/%Y').strftime('%Y-%m-%d') rescue d
    else
      nil
    end
  end

  def has_multiples?
    quiz_age_answer.present? && quiz_age_answer.answers[1] == "true"
  end

  def quiz_age_answer
    @age_answer ||= Quiz::Answer.most_recent_answers(id).select { |q|
      q.question == "age"
    }.first
  end

  # email preferences
  email_preference :new_follower_notifications
  email_preference :followed_user_updates
  email_preference :blog_updates
  email_preference :product_updates

  def followed_user_updates_sent_at
    email_preferences &&
      email_preferences['followed_user_updates_sent_at']
  end

  def followed_user_updates_sent_at=(val)
    self.email_preferences = (self.email_preferences || {}).
      merge('followed_user_updates_sent_at' => val)
  end

  def show_bookmarklet_prompt
    settings && settings['show_bookmarklet_prompt'].present? &&
      settings['show_bookmarklet_prompt'].to_s == 'true'
  end
  alias_method :show_bookmarklet_prompt?, :show_bookmarklet_prompt

  def show_bookmarklet_prompt=(show)
    self.settings = (self.settings || {}).
      merge('show_bookmarklet_prompt' => show)
  end

  protected

  def password_required?
    return false if guest? && !signup_registration?
    super
  end
end
