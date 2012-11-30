json.array! @product_types do |product_type|
  json.id product_type.id
  json.name product_type.name
  json.slug product_type.slug
  json.when_to_buy product_type.when_to_buy
  json.priority product_type.priority
  json.image_name product_type.image_name
  json.category_id product_type.category.id
  json.category product_type.category.name
end
