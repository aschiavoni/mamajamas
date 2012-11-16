json.array!(@list_entries) do |list_entry|
  json.type list_entry.class.to_s
  if list_entry.is_a? ListItem
    json.id list_entry.id
    json.name list_entry.name
    json.category_id list_entry.category.id
    json.category list_entry.category.name
    json.product_type_id list_entry.product_type.id
    json.product_type list_entry.product_type.name
    json.owned list_entry.owned
    json.link list_entry.link
    json.rating list_entry.rating
    json.when_to_buy list_entry.when_to_buy
    json.priority list_entry.priority
    json.notes list_entry.notes
    json.image_url list_entry.image_url
  else
    # ProductType
    json.id list_entry.id
    json.category_id list_entry.category.id
    json.category list_entry.category.name
    json.name list_entry.name
    json.buy_before list_entry.buy_before
    json.priority list_entry.priority
  end
end
