json.array!(@recommended_products) do |item|
  json.id item[:recommended_product].id
  json.name item[:recommended_product].name
  json.link item[:recommended_product].link
  json.vendor item[:recommended_product].vendor
  json.vendor_id item[:recommended_product].vendor_id
  json.image_url item[:recommended_product].image_url
  json.tag item[:recommended_product].tag
  json.price item[:recommended_product].price
  json.rating item[:recommended_product].rating
  json.rank item[:rank]

  if item[:product_type].present?
    json.category_id item[:product_type].category_id
    json.product_type_id item[:product_type].id
    json.product_type_name item[:product_type].name
    json.product_type_plural_name item[:product_type].plural_name
    json.product_type_image_name item[:product_type].image_name
    json.product_type_priority item[:product_type].priority
  end

  if item[:age_range].present?
    json.age_range item[:age_range].name
  end
end
