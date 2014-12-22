list_entries = @list_entries if defined?(@list_entries)
json.array!(list_entries) do |list_entry|
  json.id list_entry.id
  json.name list_entry.name
  json.category_id list_entry.category.id
  json.category list_entry.category.name
  json.product_type_name list_entry.product_type_name
  if list_entry.product_type.present?
    json.product_type_id list_entry.product_type.id
    json.product_type_plural_name list_entry.product_type.plural_name
    json.product_type_image_name list_entry.product_type.image_name
  end
  json.owned list_entry.owned
  json.link list_entry.link
  json.rating list_entry.rating
  json.has_rating list_entry.has_rating?
  json.age list_entry.age
  json.desired list_entry.desired?
  json.owned list_entry.owned?
  json.desired_quantity list_entry.desired_quantity
  json.owned_quantity list_entry.owned_quantity
  json.gifted_quantity list_entry.gifted_quantity
  json.age_position list_entry.age_range.position
  json.priority list_entry.priority
  json.notes list_entry.notes
  json.image_url list_entry.image_url
  json.placeholder list_entry.placeholder
  json.vendor list_entry.vendor
  json.vendor_id list_entry.vendor_id
  json.recommended list_entry.recommended
  json.price list_entry.price
  json.rank list_entry.rank
  json.updated_at list_entry.updated_at
end
