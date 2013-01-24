if @list_entry.is_a?(ListItem)
  json.(@list_entry, :id, :name, :link, :notes, :product_type_id, :category_id, :priority, :when_to_buy)
elsif @list_entry.is_a?(ProductType)
  json.(@list_entry, :id, :name, :category_id, :priority, :when_to_buy, :image_name)
end
