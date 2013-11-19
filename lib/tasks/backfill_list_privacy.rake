namespace :mamajamas do

  namespace :backfills do

    desc "Backfill list privacy"
    task backfill_list_privacy: :environment do
      List.where(public: true).each do |list|
        list.privacy = 1
        list.save!
      end
    end

  end

end
