class Relationship < ActiveRecord::Base
  attr_accessible :followed_id

  belongs_to(:follower,
             class_name: "User",
             touch: true)

  belongs_to(:followed,
             class_name: "User",
             touch: true,
             counter_cache: :follower_count)

  validates :follower_id, presence: true
  validates :followed_id, presence: true

  scope :pending_notification, where("delivered_notification_at IS NULL")
end
