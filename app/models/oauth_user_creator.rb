class OauthUserCreator

  attr_reader :oauth

  def initialize(oauth, username_finder = UsernameFinder)
    @oauth = oauth
    @username_finder = username_finder
  end

  def self.from_oauth(oauth)
    self.new(oauth).update_or_create
  end

  def update_or_create
    user = OauthUserFinder.find(oauth)
    user = (user.present? ? update_user(user, oauth) : create_user(oauth))
    user
  end

  private

  def create_user(oauth)
    username = username_finder.find(oauth.extracted_username)
    user = CreatesOauthUser.create(username, oauth)
    user.send_welcome_email
    user
  end

  def update_user(user, oauth)
    UpdatesOauthUser.update(user, oauth, username_finder)
  end

  def username_finder
    @username_finder
  end
end
