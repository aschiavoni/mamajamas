class RecommendedFriend
  def initialize(user)
    @user = user
  end

  def all(limit = nil)
    User.where("id <> ?", @user.id).limit(limit)
  end
end
