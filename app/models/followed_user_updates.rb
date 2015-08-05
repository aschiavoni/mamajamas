class FollowedUserUpdates
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def updates_since(since = 1.day.ago, limit = nil)
    Hash[
         user.followed_users.map { |followed|
           if followed.list.present?
             added = followed.list.list_items.
               user_items.
               not_recommended.
               added_since(since)

             added = added.limit(limit) if limit.present?
             [ followed, added ] unless added.empty?
           end
         }.reject { |x| x.blank? }
        ]
  end
end
