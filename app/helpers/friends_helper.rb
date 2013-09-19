module FriendsHelper
  def has_facebook_friends?
    @fb_friends.size > 0
  end

  def has_recommended_friends?
    @recommended_friends.size > 0
  end

  def has_any_friends?
    has_facebook_friends? || has_recommended_friends?
  end

  def find_friends_path(user)
    if user && user.guest?
      return friends_path
    end
    new_friend_path
  end
end
