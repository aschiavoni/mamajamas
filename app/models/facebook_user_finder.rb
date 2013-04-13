class FacebookUserFinder

  attr_reader :auth

  def initialize(auth, user_class = User)
    @auth = auth
    @user_class = User
  end

  def self.find(auth)
    self.new(auth).find
  end

  def find
    find_user_by_facebook_uid || find_user_by_facebook_email
  end

  private

  def provider
    auth.provider
  end

  def uid
    auth.uid.present? ? auth.uid.to_s : nil
  end

  def email
    auth.info.present? ? auth.info.email : nil
  end

  def user_class
    @user_class
  end

  def find_user_by_facebook_uid
    user_class.where(provider: provider, uid: uid).first
  end

  def find_user_by_facebook_email
    user_class.where(email: email).first
  end
end
