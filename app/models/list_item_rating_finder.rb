class ListItemRatingFinder
  def self.find(vendor_id, vendor)
    list_items = ListItem.where(vendor: vendor, vendor_id: vendor_id)
    return [] if list_items.blank? || list_items.empty?
    list_items.map(&:rating).reject { |r| r.blank? }
  end
end
