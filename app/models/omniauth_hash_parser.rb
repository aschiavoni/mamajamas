class OmniauthHashParser
  attr_accessor :provider, :uid, :access_token, :access_token_expires_at

  def initialize(omniauth_hash)
    parse(omniauth_hash)
  end

  private

  def parse(omniauth_hash)
    self.provider = omniauth_hash.provider
    self.uid = omniauth_hash.uid
    credentials = omniauth_hash.credentials

    self.access_token = credentials.token
    if credentials.expires_at.present?
      self.access_token_expires_at = Time.at(credentials.expires_at).utc
    end
  end
end
