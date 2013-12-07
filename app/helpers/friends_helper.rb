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

  def follower_count(friend)
    fc = friend.followers.count
    content_tag(:strong, "#{fc}") + " " + "follower".pluralize(fc)
  end

  def list_updated_at(friend)
    if friend.list.present?
      "#{time_ago_in_words(friend.list.updated_at)} ago"
    else
      "never"
    end
  end
end
