json.array! @available_product_types do |product_type|
  json.id product_type.id
  json.name product_type.name
  json.plural_name product_type.plural_name
  json.image_name product_type.image_name
  json.image_url image_path("products/icons/#{product_type.image_name}")
end
