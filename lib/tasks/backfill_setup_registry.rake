namespace :mamajamas do

  namespace :backfills do

    desc "Backfill setup_registry on user"
    task backfill_setup_registry: :environment do
      count = 0
      User.joins(:list).each do |user| 
        user.update_column(:setup_registry, true)
        count += 1
      end
      puts "Updated #{count} users."
    end

  end

end
