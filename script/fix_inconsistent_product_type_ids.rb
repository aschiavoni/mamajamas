ListItem.all.each do |list_item|
  if list_item.product_type.blank?
    puts "Updating #{list_item.id}..."
    pt_name = list_item.product_type_name
    pt = ProductType.find_by_name(pt_name)
    if pt.present?
      puts "Setting #{list_item.id} product type id to #{pt.id}..."
      list_item.product_type_id = pt.id
      list_item.save
    end
  end
end
