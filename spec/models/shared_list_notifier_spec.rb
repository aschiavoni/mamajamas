describe SharedListNotifier, :type => :model do

  it "delivers shared email" do
    list = build(:list)
    expect {
      SharedListNotifier.send_shared_list_notification(list)
    }.to change(ActionMailer::Base.deliveries, :size).by(1)
  end

  it "does not delivers shared email if it has already been sent" do
    list = build(:list, shared_list_notification_sent_at: Time.now.utc)
    expect {
      SharedListNotifier.send_shared_list_notification(list)
    }.not_to change(ActionMailer::Base.deliveries, :size)
  end

  it "only delivers the shared email one time" do
    list = build(:list)
    expect {
      SharedListNotifier.send_shared_list_notification(list)
      SharedListNotifier.send_shared_list_notification(list)
    }.to change(ActionMailer::Base.deliveries, :size).by(1)
  end

end
