require 'spec_helper'

describe FriendsController do

  let(:user) { create(:user) }

  before(:each) do
    sign_in user
  end

  describe "index" do

    it "should get friends list" do
      get :index
      response.should be_success
    end

    it "should assign friends" do
      get :index
      assigns(:friends).should_not be_nil
    end

  end

  describe "new" do

    it "assigns friends view" do
      get :new
      assigns(:view).should be_an_instance_of(FindFriendsView)
    end

    it "calls GoogleContactsWorker if google connected with no friends" do
      create(:authentication, provider: "google", user: user)
      GoogleContactsWorker.should_receive(:perform_async).with(user.id)
      get :new
    end

    it "does not call GoogleContactsWorker" do
      user.clear_google!
      GoogleContactsWorker.should_not_receive(:perform_async)
      get :new
    end

  end

  describe "notify" do

    it "should redirect to list" do
      post :notify
      response.should redirect_to(list_path)
    end

    describe "notifications enabled" do

      before(:all) do
        # setup some relationships
        @following = create_list(:user, 2)
        @following.each do |following|
          user.follow!(following)
        end
      end

      it "should send notifications" do
        lambda {
          post :notify, notify: "1"
        }.should change(ActionMailer::Base.deliveries, :size).by(@following.size)
      end

      it "should not re-deliver notifications to followed users" do
        # create new relationship but mark it as already having
        # sent the notification
        relationship = user.follow!(create(:user))
        relationship.delivered_notification_at = 3.days.ago
        relationship.save!

        # it should only deliver notifications for the relationships
        # that do not have delivered_notification_at set
        lambda {
          post :notify, notify: "1"
        }.should change(ActionMailer::Base.deliveries, :size).by(@following.size)
      end

    end

  end

end
