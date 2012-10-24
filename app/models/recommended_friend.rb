class RecommendedFriend
  def initialize(user)
  end

  def all(limit = nil)
    User.scoped.limit(limit)
  end
end
