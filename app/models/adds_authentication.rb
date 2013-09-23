class AddsAuthentication
  def initialize(user)
    @user = user
  end

  def from_oauth(oauth)
    attrs = {
      uid: oauth.uid,
      access_token: oauth.access_token,
      access_token_expires_at: oauth.access_token_expires_at
    }
    add(oauth.provider, attrs)
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
