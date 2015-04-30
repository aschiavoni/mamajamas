namespace :mamajamas do

  namespace :backfills do

    desc "Backfill referral ids on users"
    task backfill_referral_ids: :environment do
      generator = UserReferralIdGenerator.new
      User.all.each do |user|
        user.referral_id = generator.generate(user)
        user.save!
      end
    end

  end

end
