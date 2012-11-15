json.array!(@list_items) do |list_item|
  json.name list_item.name
  json.category_id list_item.category.id
  json.category list_item.category.name
  json.product_type_id list_item.product_type.id
  json.product_type list_item.product_type.name
  json.owned list_item.owned
  json.link list_item.link
  json.rating list_item.rating
  json.when_to_buy list_item.when_to_buy
  json.priority list_item.priority
  json.notes list_item.notes
  json.image_url list_item.image_url
end
