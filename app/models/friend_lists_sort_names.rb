module FriendListsSortNames
  def sort_name
    @sort_names ||= {
      popular: "Popularity",
      name: "Name",
      recent: "Last updated",
      expert: "Expert lists",
    }
    @sort_names[@sort] || "Popularity"
  end
end
