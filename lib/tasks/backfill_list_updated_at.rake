namespace :mamajamas do

  namespace :backfills do

    desc "Backfill updated_at timestamps on list"
    task backfill_updated_at_on_lists: :environment do

      List.where(public: true).each do |list|
        last_item_created_at = list.list_items.maximum(:created_at)

        list.updated_at = last_item_created_at
        list.save!
      end

    end

  end

end
