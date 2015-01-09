json.id @list_item.id
json.name @list_item.name
json.link @list_item.link
json.notes @list_item.notes
json.product_type_id @list_item.product_type_id
json.category_id @list_item.category_id
json.priority @list_item.priority
json.age @list_item.age
json.desired_quantity @list_item.desired_quantity
json.owned_quantity @list_item.owned_quantity
json.gifted_quantity @list_item.gifted_quantity
json.owned @list_item.owned?
json.desired @list_item.desired?
json.vendor @list_item.vendor
json.vendor_id @list_item.vendor_id
json.recommended @list_item.recommended
json.price @list_item.price
json.updated_at @list_item.updated_at
json.rank @list_item.rank
if @list_item.product_type.present?
  json.product_type_plural_name @list_item.product_type.plural_name
  json.product_type_image_name @list_item.product_type.image_name
end
