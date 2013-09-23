class UpdatesOauthUser
  def self.update(user, oauth, username_finder = UsernameFinder)
    attrs = {
      guest: false
    }

    if user.guest?
      attrs.merge!({
        username: username_finder.find(oauth.extracted_username),
        email: oauth.email,
        first_name: oauth.first_name,
        last_name: oauth.last_name
      })
    end

    ActiveRecord::Base.transaction do
      user.update_attributes!(attrs)
      AddsAuthentication.new(user).from_oauth(oauth)
    end
    user
  end
end
