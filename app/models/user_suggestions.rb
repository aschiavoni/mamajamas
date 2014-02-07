class UserSuggestions
  MAX_SUGGESTIONS = 8

  def self.suggestions(user, products)
    return products if products.blank?

    if products.size > MAX_SUGGESTIONS
      existing = existing_vendor_ids(user)
      products.reject! { |p| existing.include?(p[:vendor_id])}
    end

    products.slice(0, 8)
  end

  def self.existing_vendor_ids(user)
    ListItem.joins(:list).where("lists.user_id = ?", user.id).
      where("list_items.placeholder = ?", false).
      select("DISTINCT vendor_id").map(&:vendor_id)
  end
end
