describe SharedListNotifier do

  it "delivers shared email" do
    list = build(:list)
    lambda {
      SharedListNotifier.send_shared_list_notification(list)
    }.should change(delayed_mailer_jobs, :size).by(1)
  end

  it "does not delivers shared email if it has already been sent" do
    list = build(:list, shared_list_notification_sent_at: Time.now.utc)
    lambda {
      SharedListNotifier.send_shared_list_notification(list)
    }.should_not change(delayed_mailer_jobs, :size)
  end

  it "only delivers the shared email one time" do
    list = build(:list)
    lambda {
      SharedListNotifier.send_shared_list_notification(list)
      SharedListNotifier.send_shared_list_notification(list)
    }.should change(delayed_mailer_jobs, :size).by(1)
  end

end
