class RecommendedFriend
  attr_reader :user
  attr_reader :excluded

  def initialize(user, excluded = [])
    @user = user
    @excluded = excluded
  end

  def all(limit = nil)
    friends = User.
      includes(:list).
      where("users.id <> ?", user.id).
      where(guest: false).
      where("lists.public = true").
      limit(limit)

    friends.reject { |f| excluded.include?(f) }
  end
end
