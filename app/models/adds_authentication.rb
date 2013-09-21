class AddsAuthentication
  def initialize(user)
    @user = user
  end

  def from_oauth(oauth_hash, oauth_parser = OmniauthHashParser)
    parser = oauth_parser.new(oauth_hash)
    attrs = {
      uid: parser.uid,
      access_token: parser.access_token,
      access_token_expires_at: parser.access_token_expires_at
    }
    add(parser.provider, attrs)
  end

  def add(provider, attrs)
    auth = user.authentications.where(provider: provider).first
    if auth.present?
      auth.update_attributes!(attrs)
    else
      user.authentications.create!(attrs.merge(provider: provider))
    end
  end

  private

  def user
    @user
  end
end
