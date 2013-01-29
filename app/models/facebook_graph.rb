class FacebookGraph
  extend Memoist

  def initialize(user, profile_pic_provider = FacebookProfilePicture)
    @user = user
    @facebook = user.access_token.blank? ? nil : Koala::Facebook::API.new(user.access_token)
    @profile_pic_provider = profile_pic_provider
  end

  def friends(limit = nil)
    limit.blank? ? all_friends : all_friends.slice(0..(limit - 1))
  end
  memoize :friends

  def mamajamas_friends(limit = nil)
    limit.blank? ? all_mamajamas_friends : all_mamajamas_friends.slice(0..(limit - 1))
  end
  memoize :mamajamas_friends

  def profile_pic_url(type = :square)
    profile_pic_provider.new(user.uid, type: type).url
  end

  def post_to_wall(message, attachment = {})
    @facebook.put_wall_post(message, attachment)
  end

  private

  def user
    @user
  end

  def profile_pic_provider
    @profile_pic_provider
  end

  def facebook
    return nil if @facebook.blank?
    block_given? ? yield(@facebook) : @facebook
  rescue Koala::Facebook::APIError => e
    Rails.logger.error e.to_s
    nil
  end

  def all_friends
    user.facebook_friends
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
