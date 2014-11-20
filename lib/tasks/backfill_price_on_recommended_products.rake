namespace :mamajamas do

  namespace :backfills do

    desc "Add price to all recommended products"
    task backfill_price_on_recommended_products: :environment do
      ecs = ProductFetcherConfiguration.for('amazon')
      RecommendedProduct.all.each do |rp|
        next if rp.price.present?
        tries = 0
        begin
          amazon = CreatesRecommendedProductFromAmazonUrl.new(rp.link, ecs)
          product_attrs = amazon.product
          if (price = product_attrs[:price]).present?
            puts "Updating #{rp.id} with price: #{price}..."
            rp.price = price
            rp.save!
          end
          sleep 2
        rescue => e
          tries += 1
          if tries > 3
            raise e
          else
            sleep(2 + ( tries * 3 ))
            retry
          end
        end
      end
    end

    desc "Add price to existing recommended list items"
    task backfill_price_on_recommended_list_items: :environment do
      ListItem.recommended.each do |li|
        next if li.price.present?
        rp = RecommendedProduct.find_by(link: li.link)
        if rp.blank? || rp.price.blank?
          puts "Can't find recommended product with price for #{li.id}."
          next
        end

        puts "Updating #{li.id} with #{rp.price}..."
        li.update_column(:price, rp.price)
      end
    end

  end
end
