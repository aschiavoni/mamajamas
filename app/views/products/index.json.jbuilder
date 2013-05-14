json.array! @products do |product|
  json.id product.id
  json.name product.name
  json.display_name product.name.truncate(75, separator: ' ')
  json.vendor product.vendor
  json.vendor_id product.vendor_id
  json.url product.url
  json.image_url product.image_url
  json.rating product.rating
  json.price product.price
end
