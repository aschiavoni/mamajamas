class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable,
    :confirmable, :omniauthable

  # Virtual attribute for authenticating by either username or email
  attr_accessor :login

  # Setup accessible (or protected) attributes for your model
  attr_accessible :username, :email, :password, :password_confirmation, :remember_me
  attr_accessible :login, :provider, :uid, :access_token, :access_token_expires_at

  validates :username, presence: true, uniqueness: true

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end

  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    expires_at = auth.credentials.expires_at.blank? ? nil : Time.at(auth.credentials.expires_at).utc
    # look for a user that has already auth'ed with facebook
    user = User.where(provider: auth.provider, uid: auth.uid).first

    # if we didn't find one, look for a user with the same email
    user = User.where(email: auth.info.email).first if user.blank?

    if user.blank?
      user = User.create!(username: auth.extra.raw_info.username,
                          provider: auth.provider,
                          uid: auth.uid,
                          email: auth.info.email,
                          access_token: auth.credentials.token,
                          access_token_expires_at: expires_at,
                          password: Devise.friendly_token[0,20])
    else
      # link or refresh fb user
      user.update_attributes(provider: auth.provider,
                             uid: auth.uid,
                             access_token_expires_at: expires_at,
                             access_token: auth.credentials.token)
    end
    user
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
        user.username = data["username"] if user.username.blank?
      end
    end
  end
end
