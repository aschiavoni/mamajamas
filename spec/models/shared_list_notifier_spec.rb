describe SharedListNotifier do

  let (:list) { build(:list) }

  it "delivers shared email" do
    SharedListMailer.should_receive(:shared).
      with(an_instance_of(User)).
      once.
      and_return(double("mailer", deliver: true))
    SharedListNotifier.send_shared_list_notification(list)
  end

end
