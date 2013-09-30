require 'spec_helper'

describe GoogleContactsWorker do

  before(:each) do
    @user = create(:user)
    @auth = create(:authentication, provider: "google", user: @user)
  end

  it "updates existing social friends" do
    create(:social_friends, provider: "google", user: @user)

    GoogleContactsFetcher.any_instance.should_receive(:contacts) { [] }
    SocialFriends.any_instance.should_receive(:update_attributes!).
      with(friends: [])

    worker = GoogleContactsWorker.new
    worker.perform(@user.id)
  end

  it "creates new social friends" do
    GoogleContactsFetcher.any_instance.should_receive(:contacts) { [] }

    sf = stub
    User.any_instance.should_receive(:social_friends).exactly(2).times { sf }
    sf.should_receive(:google) { [] }
    sf.should_receive(:create!).with(provider: "google", friends: [])

    worker = GoogleContactsWorker.new
    worker.perform(@user.id)
  end

end
