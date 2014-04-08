class RecommendedFriend
  attr_reader :user
  attr_reader :excluded

  def initialize(user, excluded = [])
    @user = user
    @excluded = excluded
  end

  def all(limit = nil)
    friends = get_friends
    friends = friends.reject { |f| excluded.include?(f) }
    limit.present? ? friends.take(limit) : friends
  end

  def not_following(limit = nil)
    friends = get_friends(true)
    friends = friends.reject { |f| excluded.include?(f) }
    limit.present? ? friends.take(limit) : friends
  end

  def with_pics(limit = nil)
    friends = get_friends(false, true)
    friends = friends.reject { |f| excluded.include?(f) }
    limit.present? ? friends.take(limit) : friends
  end

  private

  def get_friends(exclude_following = false, exclude_no_pics = false)
    users = User.
      includes(:list).
      where("users.id <> ?", user.id).
      where(guest: false).
      where("lists.privacy <> ?", List::PRIVACY_PRIVATE)

    if exclude_following
      followed_ids = user.relationships.map(&:followed_id)
      unless followed_ids.empty?
        users = users.where("users.id NOT IN (?)", followed_ids)
      end
    end

    if exclude_no_pics
      users = users.where("profile_picture IS NOT NULL")
    end

    users.order("lists.featured DESC, users.follower_count DESC")
  end
end
