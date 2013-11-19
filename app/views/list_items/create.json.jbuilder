json.id @list_entry.id
json.name @list_entry.name
json.link @list_entry.link
json.notes @list_entry.notes
json.product_type_id @list_entry.product_type_id
json.category_id @list_entry.category_id
json.priority @list_entry.priority
json.age @list_entry.age
json.quantity @list_entry.quantity
json.vendor @list_entry.vendor
json.vendor_id @list_entry.vendor_id
if @list_entry.product_type.present?
  json.product_type_plural_name @list_entry.product_type.plural_name
  json.product_type_image_name @list_entry.product_type.image_name
end
