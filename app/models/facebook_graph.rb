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
    "http://graph.facebook.com/#{uid}/picture?type=large"
  end

  def refresh_access_token
    oauth = Koala::Facebook::OAuth.new(FACEBOOK_CONFIG["app_id"], FACEBOOK_CONFIG["secret_key"])
    access_token_info = oauth.exchange_access_token_info(@user.access_token)
    expires_at = (Time.now.utc + access_token_info['expires'].to_i.seconds)
    @user.update_attributes(access_token: access_token_info['access_token'],
                            access_token_expires_at: expires_at)
    @facebook = @user.access_token.blank? ? nil : Koala::Facebook::API.new(@user.access_token)
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
    Rails.logger.error.to_s
    self.refresh_access_token
    block_given? ? yield(@facebook) : @facebook
  end

  def all_friends
    return [] if facebook.blank?
    facebook do |fb|
      fb.get_connection('me', 'friends',
                        :fields => "id,name,first_name,last_name,picture",
                        :type => "normal")
    end
  end
  memoize :all_friends

  def all_mamajamas_friends
    return [] if all_friends.blank?
    # get all the uids of fb friends
    uids = all_friends.map { |f| f["id"] }
    # get all the mamajamas users that have matching uids
    mjs_uids = User.where(uid: uids).pluck(:uid).to_set

    # filter friends hash to only include uids that have
    # corresponding mamajamas accounts
    # TODO: this probably can be optimized
    all_friends.select do |friend|
      mjs_uids.include?(friend["id"])
    end
  end
  memoize :all_mamajamas_friends
end
