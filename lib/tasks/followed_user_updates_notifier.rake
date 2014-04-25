namespace :mamajamas do

  namespace :notifications do

    desc "Send followed user updates emails for all registered users"
    task followed_user_updates: :environment do
      User.registered.each do |user|
        FollowedUserUpdatesMailer.daily_digest(user.id).deliver
      end
    end

  end
end
