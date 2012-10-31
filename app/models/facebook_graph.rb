class FacebookGraph
  extend Memoist

  def initialize(user)
    @user = user
    @facebook = user.access_token.blank? ? nil : Koala::Facebook::API.new(user.access_token)
  end

  def friends(limit = nil)
    limit.blank? ? all_friends : all_friends.slice(0..(limit - 1))
  end
  memoize :friends

  def mamajamas_friends(limit = nil)
    limit.blank? ? all_mamajamas_friends : all_mamajamas_friends.slice(0..(limit - 1))
  end
  memoize :mamajamas_friends

  def profile_pic_url(uid)
    "http://graph.facebook.com/#{uid}/picture?type=square"
  end

  def self.extract_facebook_username(oauth_params)
    raw_info = oauth_params['extra']['raw_info']
    return raw_info['username'] unless raw_info['username'].blank?
    return "#{raw_info['first_name']}#{raw_info['last_name']}"
  end

  private

  def facebook
    return nil if @facebook.blank?
    block_given? ? yield(@facebook) : @facebook
  rescue Koala::Facebook::APIError => e
    Rails.logger.error e.to_s
    nil
  end

  def all_friends
    @user.facebook_friends
  end
  memoize :all_friends

  def all_mamajamas_friends
    return [] if all_friends.blank?
    uids = all_friends.map { |f| f["id"] }
    # get all the mamajamas users that have matching uids
    User.where(uid: uids)
  end
  memoize :all_mamajamas_friends
end
