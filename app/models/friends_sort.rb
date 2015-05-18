module FriendsSort
  def sort_by(sort_by)
    default_sort = "lists.featured DESC, users.follower_count DESC"
    return default_sort if sort_by.blank?

    case sort_by.to_sym
    when :popular
      "users.follower_count DESC, lists.featured DESC"
    when :name
      "users.username ASC, lists.featured DESC"
    when :recent
      "lists.updated_at DESC, lists.featured DESC"
    when :expert
      "lists.expert DESC, users.follower_count DESC"
    else
      default_sort
    end
  end
end
