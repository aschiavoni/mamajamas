namespace :mamajamas do

  namespace :backfills do

    desc "Backfill image_url on list items"
    task backfill_image_url_on_list_items: :environment do

      pattern = /\/assets\//
      ListItem.all.each do |list_item|
        if list_item.image_url =~ /^\/assets/
          image_name = list_item.image_url.gsub(pattern, "")
          list_item.update_column(:image_url, image_name)
        end
      end

      ProductType.all.each do |product_type|
        image_name = product_type.image_name
        product_type.update_column(:image_name, "products/icons/#{image_name}")
      end

    end

  end

end

