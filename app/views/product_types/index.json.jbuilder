json.array! @product_types do |product_type|
  json.id product_type.id
  json.name product_type.name
  json.slug product_type.slug
  json.buy_before product_type.buy_before
  json.priority product_type.priority
  json.image_name product_type.image_name
  json.category_id product_type.category.id
  json.category product_type.category.name
end
