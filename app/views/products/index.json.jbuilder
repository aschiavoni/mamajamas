json.array! @products do |product|
  json.id product.id
  json.name product.name
  json.vendor product.vendor
  json.vendor_id product.vendor_id
  json.url product.url
  json.image_url product.image_url
  json.rating product.rating
  json.product_type_id @product_type.id
  json.product_type @product_type.name
end
