class FacebookGraph
  extend Memoist

  def initialize(user)
    @user = user
    @facebook = user.access_token.blank? ? nil : Koala::Facebook::API.new(user.access_token)
  end

  def friends(limit = nil)
    return {} if facebook.blank?
    facebook do |fb|
      my_friends = fb.get_connection('me', 'friends',
                                     :fields => "id,name,first_name,last_name,picture",
                                     :type => "normal")
      limit.blank? ? my_friends : my_friends.slice(0..(limit - 1))
    end
  end
  memoize :friends

  def mamajamas_friends(limit = nil)
    # get all the uids of fb friends
    uids = friends.map { |f| f["id"] }
    # get all the mamajamas users that have matching uids
    mjs_uids = User.where(uid: uids).pluck(:uid).to_set

    # filter friends hash to only include uids that have
    # corresponding mamajamas accounts
    # TODO: this probably can be optimized
    friends.select do |friend|
      mjs_uids.include?(friend["id"])
    end
  end
  memoize :mamajamas_friends

  def profile_pic_url(uid)
    "http://graph.facebook.com/#{uid}/picture?type=large"
  end

  def refresh_access_token
    puts "refreshing access token"
    oauth = Koala::Facebook::OAuth.new(FACEBOOK_CONFIG["app_id"], FACEBOOK_CONFIG["secret_key"])
    access_token = oauth.exchange_access_token_info(@user.access_token)
    @user.update_attributes(access_token: access_token)
    puts @user.inspect
    @facebook = @user.access_token.blank? ? nil : Koala::Facebook::API.new(@user.access_token)
    puts @facebook.inspect
  end

  def self.extract_facebook_username(oauth_params)
    raw_info = oauth_params['extra']['raw_info']
    return raw_info['username'] unless raw_info['username'].blank?
    return "#{raw_info['first_name']}#{raw_info['last_name']}"
  end

  private

  # TODO: review if this is the best way to refresh a user's access token
  def facebook
    puts "facebook"
    return nil if @facebook.blank?
    block_given? ? yield(@facebook) : @facebook
  rescue Koala::Facebook::APIError => e
    puts "error"
    Rails.logger.info e.to_s
    puts e.to_s
    self.refresh_access_token
    block_given? ? yield(@facebook) : @facebook
    nil # or consider a custom null object
  end
end
