class CreatesOauthUser
  def self.create(username, oauth)
    user = nil
    ActiveRecord::Base.transaction do
      user = User.create!({
        username: username,
        email: oauth.email,
        first_name: oauth.first_name,
        last_name: oauth.last_name,
        password: GeneratesRandomPassword.generate,
        guest: false
      })
      AddsAuthentication.new(user).from_oauth(oauth)
    end
    user
  end
end
