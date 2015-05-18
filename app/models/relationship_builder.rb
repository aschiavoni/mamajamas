class RelationshipBuilder
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def build_relationships(friends)
    friends.each do |friend|
      user.follow!(friend)
    end
    user.update_attributes!(relationships_created_at: Time.now.utc)
  end
end
