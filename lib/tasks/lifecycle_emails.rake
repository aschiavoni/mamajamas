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
  end
end
