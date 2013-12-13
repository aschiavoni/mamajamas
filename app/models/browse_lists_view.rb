class BrowseListsView
  extend Memoist

  def recommended
    BrowseLists.recommended
  end
  memoize :recommended
end
