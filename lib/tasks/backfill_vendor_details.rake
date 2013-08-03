namespace :mamajamas do

  namespace :backfills do

    # this is not perfect and is slow but only needs to be run once

    desc "Backfill vendor details"
    task vendor_details: :environment do
      ListItem.user_items.where(vendor: nil).each do |list_item|
        product_type = list_item.product_type
        product_attrs = nil

        if product_type.present?
          suggestions = CachedProductTypeSuggestions.find(product_type)
          product_attrs = suggestions[:suggestions].select do |suggestion|
            suggestion["url"] == list_item.link
          end.first
        end

        if product_attrs.blank?
          results = ProductSearcher.search(list_item.name)
          product_attrs = results.select do |product|
            product.url == list_item.link
          end.first
        end

        if product_attrs.present?
          puts "Updating #{list_item.name} for user: #{list_item.list.user.username}..."
          list_item.vendor = product_attrs["vendor"]
          list_item.vendor_id = product_attrs["vendor_id"]
          list_item.save!
        end
      end
    end

  end

end
