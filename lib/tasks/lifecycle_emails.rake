namespace :mamajamas do
  namespace :lifecycle_emails do

    desc "Send post due ratings lifecycle email"
    task post_due_ratings: :environment do
      anchor_date = 60.days.ago.to_date
      users = User.registered
        .where.not(baby_due_date: nil)
        .where('baby_due_date < ?', anchor_date)
        .where.not("defined(email_preferences, 'lifecyle_email_post_due_ratings_sent_at')")
      users.each do |user|
        LifecycleMailer.post_due_ratings(user.id).deliver
        user.lifecyle_email_post_due_ratings_sent_at = Time.now.utc
        user.save!
      end
    end
  end
end
