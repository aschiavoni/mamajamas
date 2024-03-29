json.array! @products do |product|
  json.name product.name
  json.display_name product.name.truncate(75, separator: ' ')
  json.vendor product.vendor
  json.vendor_name product.vendor_name
  json.vendor_id product.vendor_id
  json.url product.url
  json.image_url product.image_url
  json.medium_image_url product.medium_image_url
  json.large_image_url product.large_image_url
  json.rating product.rating
  json.price product.price
end
