# 53.6: FacebookUserCreator::from_oauth
class FacebookUserCreator

  attr_reader :auth

  def initialize(auth)
   @auth = auth
  end

  def self.from_oauth(auth)
    self.new(auth).update_or_create
  end

  def update_or_create
    user = find_user
    user = user.blank? ? create_user : update_user(user)
    user
  end

  def expires_at
    if auth.credentials.expires_at.blank?
      nil
    else
      Time.at(auth.credentials.expires_at).utc
    end
  end

  def facebook_username
    raw_info = auth.extra.raw_info
    return raw_info.username unless raw_info.username.blank?
    "#{raw_info.first_name}#{raw_info.last_name}"
  end

  private

  def find_user
    find_user_by_facebook_uid || find_user_by_facebook_email
  end

  def find_user_by_facebook_uid
    User.where(provider: auth.provider, uid: auth.uid).first
  end

  def find_user_by_facebook_email
    User.where(email: auth.info.email).first
  end

  def create_user
    User.create!({
      username: facebook_username,
      provider: auth.provider,
      uid: auth.uid,
      email: auth.info.email,
      first_name: auth.info.first_name,
      last_name: auth.info.last_name,
      access_token: auth.credentials.token,
      access_token_expires_at: expires_at,
      password: random_password,
      guest: false,
    }, without_protection: true)
  end

  def update_user(user)
    attrs = {
      provider: auth.provider,
      uid: auth.uid,
      first_name: auth.info.first_name,
      last_name: auth.info.last_name,
      access_token_expires_at: expires_at,
      access_token: auth.credentials.token,
      guest: false
    }

    if user.guest?
      attrs.merge!({
        username: facebook_username,
        email: auth.info.email
      })
    end

    user.update_attributes(attrs, without_protection: true)
    user
  end

  def random_password
    SecureRandom.base64(15).tr('+/=lIO0', 'pqrsxyz')[0, 20]
  end
end
