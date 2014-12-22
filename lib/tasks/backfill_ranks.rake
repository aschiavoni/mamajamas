namespace :mamajamas do

  namespace :backfills do

    desc "Seed rank on all product types"
    task seed_ranks: :environment do
      ranked = [
        'Infant Car Seat',
        'Stroller',
        'Carrier or Wrap',
        'Crib',
        'Monitor',
        'Disposable Diapers',
        'Wipes',
        'Diaper Pail',
        'Bath Tub',
      ]

      ranked.each_with_index do |product_type_name, idx| 
        pt = ProductType.find_by(name: product_type_name)
        if pt.blank?
          puts "Could not find #{product_type_name}."
          next
        end

        rank = (idx + 1) * 10
        pt.update_column('rank', rank)
        puts "Updated #{product_type_name}."
      end
      puts "Done."
    end

    desc "Backfill rank on existing list items"
    task backfill_ranks: :environment do
      ProductType.where.not(rank: nil).each do |product_type| 
        puts "Looking for #{product_type.plural_name}..."
        ListItem.where(product_type_id: product_type.id).each do |li| 
          puts "Updating #{li.id}..."
          li.update_column('rank', product_type.rank)
        end
      end
      puts "Done."
    end

  end

end
