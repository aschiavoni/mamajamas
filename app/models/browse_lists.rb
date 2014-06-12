class BrowseLists
  include FriendsSort

  def initialize(sort = nil)
    @sort = sort
  end

  def recommended
    User.
      includes(:list).
      where(guest: false).
      where("lists.privacy <> ?", List::PRIVACY_PRIVATE).
      order(sort_by(@sort))
  end
end
