class SharedListNotifier
  def self.send_shared_list_notification(list)
    user = list.user
    SharedListMailer.shared(user).deliver
  end
end
