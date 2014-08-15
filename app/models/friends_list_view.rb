class FriendsListView
  include FriendsSort
  include FriendListsSortNames

  attr_reader :user

  def initialize(user = nil, sort = nil)
    @user = user
    @sort = sort.present? ? sort.to_sym : nil
  end

  def following
    @following ||= user.followed_users.includes(:list).
      order(sort_by(@sort))
  end

  def followers
    @followers = user.followers.includes(:list).
      where("lists.privacy <> ?", List::PRIVACY_PRIVATE).
      references(:lists).
      order(sort_by(@sort))
  end
end
