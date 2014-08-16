require 'spec_helper'

describe GoogleContactsWorker do

  before(:each) do
    @user = create(:user)
    @auth = create(:authentication, provider: "google", user: @user)
  end

  it "updates existing social friends" do
    create(:social_friends, provider: "google", user: @user)

    expect_any_instance_of(GoogleContactsFetcher).to receive(:contacts) { [] }
    expect_any_instance_of(SocialFriends).to receive(:update_attributes!).
      with(friends: [])

    worker = GoogleContactsWorker.new
    worker.perform(@user.id)
  end

  it "creates new social friends" do
    expect_any_instance_of(GoogleContactsFetcher).to receive(:contacts) { [] }

    sf = double
    expect_any_instance_of(User).to receive(:social_friends).exactly(2).times { sf }
    expect(sf).to receive(:google) { [] }
    expect(sf).to receive(:create!).with(provider: "google", friends: [])

    worker = GoogleContactsWorker.new
    worker.perform(@user.id)
  end

end
