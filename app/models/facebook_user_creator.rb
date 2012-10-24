class FacebookUserCreator
  def self.from_oauth(auth, signed_in_resource=nil)
    expires_at = auth.credentials.expires_at.blank? ? nil : Time.at(auth.credentials.expires_at).utc

    # look for a user that has already auth'ed with facebook
    user = User.where(provider: auth.provider, uid: auth.uid).first

    # if we didn't find one, look for a user with the same email
    user = User.where(email: auth.info.email).first if user.blank?

    if user.blank?
      user = User.create!(username: FacebookGraph.extract_facebook_username(auth),
                          provider: auth.provider,
                          uid: auth.uid,
                          email: auth.info.email,
                          first_name: auth.info.first_name,
                          last_name: auth.info.last_name,
                          access_token: auth.credentials.token,
                          access_token_expires_at: expires_at,
                          password: Devise.friendly_token[0,20])
    else
      # link or refresh fb user
      user.update_attributes(provider: auth.provider,
                             uid: auth.uid,
                             first_name: auth.info.first_name,
                             last_name: auth.info.last_name,
                             access_token_expires_at: expires_at,
                             access_token: auth.credentials.token)
    end
    user
  end
end
