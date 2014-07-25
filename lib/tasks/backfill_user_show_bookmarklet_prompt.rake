namespace :mamajamas do

  namespace :backfills do

    desc "Update show_bookmarklet_prompt on users"
    task backfill_show_bookmarklet_prompt: :environment do
      User.registered.each do |user|
        user.update_attributes!(show_bookmarklet_prompt: true)
      end
    end
  end
end
