json.(@list_item_image, :id, :user_id)
json.image do
  json.name @list_item_image.image.thumb.filename
  json.url @list_item_image.image.thumb.url
  json.size @list_item_image.image.thumb.size
end
