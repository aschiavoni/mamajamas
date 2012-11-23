json.array! @products do |product|
  json.id product.id
  json.name product.name
  json.vendor product.vendor
  json.vendor_id product.vendor_id
  json.url product.url
  json.rating product.rating
  json.product_type_id product.product_type_id
  json.product_type product.product_type.name
end
