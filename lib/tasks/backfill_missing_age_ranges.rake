namespace :mamajamas do

  namespace :backfills do

    desc "Backfill missing age ranges (5y bug)"
    task backfill_missing_age_ranges: :environment do
      five_year = AgeRange.find_by_name("5y+")
      ListItem.user_items.where(age_range_id: nil).each do |li|
        puts "Updating #{li.name} (#{li.id})..."
        li.age_range = five_year
        li.save!
      end
    end

  end

end
