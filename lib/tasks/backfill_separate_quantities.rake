namespace :mamajamas do

  namespace :backfills do

    desc "Backfill desired and owned quantities on list items and product types"
    task backfill_separate_quantities: :environment do
      ListItem.all.each do |list_item|
        if list_item.owned?
          list_item.owned_quantity = list_item.quantity
        else
          list_item.desired_quantity = list_item.quantity
        end
        puts "Updating list item: #{list_item.id}..."
        list_item.save!
      end
      puts "Done."
    end

  end

end
