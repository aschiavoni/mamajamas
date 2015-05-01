class FacebookGraph
  extend Memoist

  def initialize(user, facebook_authentication, profile_pic_provider = FacebookProfilePicture)
    @user = user
    @authentication = facebook_authentication
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
    profile_pic_provider.new(authentication.uid, type: type).url
  end

  def profile_pic_url(width, height)
    profile_pic_provider.new(authentication.uid, width: width, height: height).url
  end

  def post_to_wall(message, attachment = {})
    fb_api.put_wall_post(message, attachment)
  end

  private

  def user
    @user
  end

  def authentication
    @authentication
  end

  def profile_pic_provider
    @profile_pic_provider
  end

  def fb_api
    @facebook = nil
    if authentication.present? && authentication.access_token.present?
      @facebook = Koala::Facebook::API.new(authentication.access_token)
    end
  end
  memoize :fb_api

  def facebook
    return nil if fb_api.blank?
    block_given? ? yield(fb_api) : fb_api
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
    # get all the mamajamas users that have matching uids and public lists
    User.
      includes(:list).
      joins(:authentications).
      where("authentications.uid" => uids).
      where("lists.privacy <> ?", List::PRIVACY_PRIVATE).
      references(:authentications).
      references(:lists).
      order("lists.featured DESC, users.created_at DESC, users.follower_count DESC")
  end
  memoize :all_mamajamas_friends
end
