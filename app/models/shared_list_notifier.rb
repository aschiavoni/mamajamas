class SharedListNotifier
  def self.send_shared_list_notification(list)
    user = list.user
    if list.shared_list_notification_sent_at.blank?
      SharedListMailer.delay.shared(user.id)
      list.update_attributes!({
        shared_list_notification_sent_at: Time.now.utc
      }, { without_protection: true })
    end
  end
end
