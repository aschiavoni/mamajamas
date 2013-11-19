namespace :mamajamas do

  namespace :backfills do

    desc "Backfill quantity on list items and product types"
    task backfill_quantities: :environment do
      ListItem.update_all(quantity: 1)
      ProductType.update_all(recommended_quantity: 1)
    end

  end

end
