module ListsHelper
  def save_button_text(list)
    list.shared_list_notification_sent_at.present? ? "Share" : "Save"
  end
end
