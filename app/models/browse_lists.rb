class BrowseLists
  def self.recommended
    User.
      includes(:list).
      where(guest: false).
      where("lists.privacy <> ?", List::PRIVACY_PRIVATE).
      order("lists.featured DESC, users.follower_count DESC")
  end
end
