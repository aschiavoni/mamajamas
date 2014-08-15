require 'spec_helper'

describe FriendsController, :type => :controller do

  describe "index" do

    before(:each) do
      @user = create(:user)
      sign_in @user
    end

    it "should get friends list" do
      get :index
      expect(response).to be_success
    end

  end

  describe "new" do

    before(:each) do
      @user = create(:user)
      sign_in @user
    end

    it "assigns friends view" do
      get :new
      expect(assigns(:view)).to be_an_instance_of(FindFriendsView)
    end

    it "calls GoogleContactsWorker if google connected with no friends" do
      create(:authentication, provider: "google", user: @user)
      expect(GoogleContactsWorker).to receive(:perform_async).with(@user.id)
      get :new
    end

    it "does not call GoogleContactsWorker" do
      @user.clear_google!
      expect(GoogleContactsWorker).not_to receive(:perform_async)
      get :new
    end

  end

  describe "notify" do


    it "should redirect to list" do
      @user = create(:user)
      sign_in @user
      post :notify
      expect(response).to redirect_to(list_path)
    end

    describe "notifications enabled" do

      before(:each) do
        # setup some relationships
        @user = create(:user)
        sign_in @user
        @following = create_list(:user, 2)
        @following.each do |following|
          @user.follow!(following)
        end
      end

      it "should send notifications" do
        expect {
          post :notify, notify: "1"
        }.to change(ActionMailer::Base.deliveries, :size).by(@following.size)
      end

      it "should not re-deliver notifications to followed users" do
        # create new relationship but mark it as already having
        # sent the notification
        relationship = @user.follow!(create(:user))
        relationship.delivered_notification_at = 3.days.ago
        relationship.save!

        # it should only deliver notifications for the relationships
        # that do not have delivered_notification_at set
        expect {
          post :notify, notify: "1"
        }.to change(ActionMailer::Base.deliveries, :size).by(@following.size)
      end

    end

  end

end
