# 53.6: FacebookUserCreator::from_oauth
class FacebookUserCreator

  attr_reader :auth

  def initialize(auth, username_finder = UsernameFinder)
    @auth = auth
    @username_finder = username_finder
  end

  def self.from_oauth(auth)
    self.new(auth).update_or_create
  end

  def update_or_create
    user = FacebookUserFinder.find(auth)
    user = user.blank? ? create_user : update_user(user)
    user.send_welcome_email
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
    raw_username = raw_info.username
    if raw_info.first_name.present?
      raw_username = "#{raw_info.first_name}#{raw_info.last_name}"
    end
    raw_username.downcase
  end

  private

  def create_user
    User.create!({
      username: username_finder.find(facebook_username),
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
        username: username_finder.find(facebook_username),
        email: auth.info.email
      })
    end

    user.update_attributes(attrs, without_protection: true)
    user
  end

  def random_password
    SecureRandom.base64(15).tr('+/=lIO0', 'pqrsxyz')[0, 20]
  end

  def username_finder
    @username_finder
  end
end
