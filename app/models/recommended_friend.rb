class RecommendedFriend
  attr_reader :user
  attr_reader :excluded

  def initialize(user, excluded = [])
    @user = user
    @excluded = excluded
  end

  def all(limit = nil)
    friends = User.where("id <> ?", user.id).limit(limit)
    friends.reject { |f| excluded.include?(f) }
  end
end
