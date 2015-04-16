namespace :mamajamas do
  namespace :lifecycle_emails do

    desc "Send post due ratings lifecycle email"
    task post_due_ratings: :environment do
      end_date = 60.days.ago.to_date
      start_date = 90.days.ago.to_date
      users = User.registered
        .where.not(baby_due_date: nil)
        .where(baby_due_date: start_date..end_date)
        .where.not("defined(email_preferences, 'lifecycle_email_post_due_ratings_sent_at')")
      users.each do |user|
        LifecycleMailer.post_due_ratings(user.id).deliver
        user.lifecycle_email_post_due_ratings_sent_at = Time.now.utc
        user.save!
      end
    end

    desc "Send baby shower lifecycle email"
    task baby_shower: :environment do
      start_date = 90.days.from_now.to_date
      end_date = 91.days.from_now.to_date

      users = User.registered
        .where.not(baby_due_date: nil)
        .where('baby_due_date <= ?', start_date)
        .where('created_at >= ?', 3.days.ago.to_date)
        .where.not("defined(email_preferences, 'lifecycle_email_baby_shower_sent_at')")
      users.each do |user|
        send_baby_shower_email(user)
      end

      users = User.registered
        .where.not(baby_due_date: nil)
        .where(baby_due_date: start_date..end_date)
        .where.not("defined(email_preferences, 'lifecycle_email_baby_shower_sent_at')")
      users.each do |user|
        send_baby_shower_email(user)
      end
    end

    def send_baby_shower_email(user)
      LifecycleMailer.baby_shower(user.id).deliver
      user.lifecycle_email_baby_shower_sent_at = Time.now.utc
      user.save!
    end
  end
end
