class FindFriendsView
  FACEBOOK_PROVIDER = "facebook"

  extend Memoist

  def initialize(user)
    @user = user
  end

  def email_invite
    @email_invite ||= Invite.new do |i|
      i.user = user
      i.provider = "mamajamas"
    end
  end

  def facebook_invites
    user.facebook_friends.map do |friend|
      unless mamajamas_facebook_friend_ids.include?(friend[:id])
        existing_facebook_invites[friend[:id]] ||
          build_invite_from_facebook_friend(friend)
      end
    end.reject { |f| f.blank? }
  end
  memoize :facebook_invites

  def mamajamas_facebook_friends
    user.facebook.mamajamas_friends
  end
  memoize :mamajamas_facebook_friends

  def mamajamas_facebook_friend_ids
    mamajamas_facebook_friends.map(&:uid)
  end
  memoize :mamajamas_facebook_friend_ids

  def existing_facebook_invites
    Hash[user.invites.where(provider: FACEBOOK_PROVIDER).map do |invite|
      [ invite.uid, invite  ]
    end]
  end
  memoize :existing_facebook_invites

  private

  def user
    @user
  end

  def build_invite_from_facebook_friend(friend)
    uid = friend[:id]
    Invite.new do |i|
      i.user_id = user.id
      i.uid = uid
      i.name = friend[:name]
      i.provider = FACEBOOK_PROVIDER
      i.picture_url = FacebookProfilePicture.new(uid, picture_options).url
    end
  end

  def picture_options
    @pic_opts ||= { width: 86, height: 86 }
  end
end
