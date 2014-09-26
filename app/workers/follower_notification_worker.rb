class FollowerNotificationWorker
  include Sidekiq::Worker
  include WorkerLogger

  sidekiq_options({ unique: :all })

  def perform(user_id)
    log "#{user_id}: Looking for user #{user_id}..."
    user = User.find(user_id)

    return if user.list.blank?

    since = user.followed_user_updates_sent_at || 1.day.ago
    added = user.list.list_items.user_items.not_recommended.added_since(since)
    log "#{user_id}Found #{added.size} items"

    unless added.empty?
      user.update_attributes!({ followed_user_updates_sent_at: Time.now.utc },
                              { without_protection: true })

      user.followers.each do |follower|
        next if follower.guest? || follower.followed_user_updates_disabled?
        log "#{user_id} Notifying user: #{follower.username}..."
        FollowedUserUpdatesMailer.notify(follower.id, user, added).deliver
      end
    end
  end
end
