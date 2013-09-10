class FindFriendsView
  extend Memoist

  def initialize(user)
    @user = user
  end

  def facebook_invites
    user.facebook_friends.map do |friend|
      unless mamajamas_facebook_friend_ids.include?(friend[:id])
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

  private

  def user
    @user
  end

  def build_invite_from_facebook_friend(friend)
    uid = friend[:id]
    Invite.new do |i|
      i.uid = uid
      i.name = friend[:name]
      i.provider = "facebook"
      i.picture_url = "https://graph.facebook.com/#{uid}/picture?width=86&height=86&access_token=#{user.access_token}"
    end
  end
end
