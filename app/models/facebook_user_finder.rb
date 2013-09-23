class FacebookUserFinder
  attr_reader :oauth

  def initialize(oauth, user_class = User)
    @oauth = oauth
    @user_class = User
  end

  def self.find(oauth)
    self.new(oauth).find
  end

  def find
    find_user_by_facebook_uid || find_user_by_facebook_email
  end

  private

  def oauth
    @oauth
  end

  def user_class
    @user_class
  end

  def find_user_by_facebook_uid
    user_class.joins(:authentications).
      where("authentications.provider" => oauth.provider).
      where("authentications.uid" => oauth.uid).
      readonly(false).
      first
  end

  def find_user_by_facebook_email
    user_class.where(email: oauth.email).first
  end
end
