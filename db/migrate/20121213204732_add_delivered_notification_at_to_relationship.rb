class AddDeliveredNotificationAtToRelationship < ActiveRecord::Migration
  def change
    add_column :relationships, :delivered_notification_at, :datetime
  end
end
