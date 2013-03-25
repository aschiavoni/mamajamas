json.(@list_item_image, :id, :user_id)
json.image do
  json.name @list_item_image.image.filename
  json.url @list_item_image.image.url
  json.size @list_item_image.image.size
end
