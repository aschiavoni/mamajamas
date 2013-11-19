namespace :mamajamas do

  namespace :backfills do

    desc "Backfill rating on list items with nil ratings"
    task backfill_nil_ratings: :environment do
      ListItem.update_all({ rating: 0 }, { rating: nil })
    end

  end

end
