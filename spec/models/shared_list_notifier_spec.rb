describe SharedListNotifier do

  it "delivers shared email" do
    list = build(:list)
    SharedListMailer.should_receive(:shared).
      with(an_instance_of(User)).
      once.
      and_return(double("mailer", deliver: true))
    SharedListNotifier.send_shared_list_notification(list)
  end

  it "does not delivers shared email if it has already been sent" do
    list = build(:list, shared_list_notification_sent_at: Time.now.utc)
    SharedListMailer.should_not_receive(:shared)
    SharedListNotifier.send_shared_list_notification(list)
  end

  it "only delivers the shared email one time" do
    list = build(:list)
    SharedListMailer.should_receive(:shared).
      with(an_instance_of(User)).
      once.
      and_return(double("mailer", deliver: true))
    SharedListNotifier.send_shared_list_notification(list)
    SharedListNotifier.send_shared_list_notification(list)
  end

end
