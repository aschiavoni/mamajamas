namespace :mamajamas do

  namespace :backfills do

    desc "Backfill baby due date"
    task backfill_baby_due_date: :environment do
      User.all.each do |user| 
        dd = Date.strptime(user.due_date,
                           I18n.t("date.formats.default")) rescue nil
        user.baby_due_date = dd if dd.present?
        user.save!
      end
    end

  end

end
