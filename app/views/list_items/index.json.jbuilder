json.array!(list_entries) do |list_entry|
  json.id list_entry.id
  json.name list_entry.name
  json.category_id list_entry.category.id
  json.category list_entry.category.name
  json.product_type_name list_entry.product_type_name
  json.product_type_name_plural list_entry.product_type_name.try(:pluralize)
  if list_entry.product_type.present?
    json.product_type_id list_entry.product_type.id
  end
  json.owned list_entry.owned
  json.link list_entry.link
  json.rating list_entry.rating
  json.age list_entry.age
  json.age_position list_entry.age_range.position
  json.priority list_entry.priority
  json.notes list_entry.notes
  json.image_url list_entry.image_url
  json.placeholder list_entry.placeholder
end
