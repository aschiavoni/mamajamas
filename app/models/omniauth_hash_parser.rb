class OmniauthHashParser
  attr_accessor :provider, :uid, :access_token, :access_token_expires_at
  attr_accessor :email, :first_name, :last_name
  attr_accessor :username, :extracted_username

  def initialize(omniauth_hash)
    parse(omniauth_hash)
  end

  private

  def parse(omniauth_hash)
    self.provider = omniauth_hash.provider
    self.uid = omniauth_hash.uid.to_s
    parse_credentials(omniauth_hash.credentials)
    parse_info(omniauth_hash.info)
    parse_usernames(omniauth_hash)
  end

  def parse_credentials(credentials)
    return if credentials.blank?
    self.access_token = credentials.token
    if credentials.expires_at.present?
      self.access_token_expires_at = Time.at(credentials.expires_at).utc
    end
  end

  def parse_info(info)
    return if info.blank?
    self.first_name = info.first_name
    self.last_name = info.last_name
    self.email = info.email
  end

  def parse_usernames(omniauth_hash)
    info = omniauth_hash.info
    self.extracted_username = "#{info.first_name}#{info.last_name}".downcase
    if omniauth_hash.extra.present? && omniauth_hash.extra.raw_info.present?
      self.username = omniauth_hash.extra.raw_info.username
    end
    self.username = self.extracted_username if self.username.blank?
    self.username.downcase!
  end
end
