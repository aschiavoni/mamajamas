class AddSharedListNotificationSentAtToList < ActiveRecord::Migration
  def change
    add_column :lists, :shared_list_notification_sent_at, :datetime
  end
end
