namespace :mamajamas do

  namespace :backfills do

    desc "Update followers count counter cache"
    task backfill_follower_count: :environment do
      User.all.each do |user|
        User.reset_counters(user.id, :followers)
      end
    end

  end

end
