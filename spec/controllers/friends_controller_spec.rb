require 'spec_helper'

describe FriendsController do

  before(:each) do
    @user = create(:user)
    sign_in @user
  end

  describe "index" do

    it "should get friends list" do
      get :index
      response.should be_success
    end

  end

  describe "notify" do

    it "should redirect to list" do
      post :notify
      response.should redirect_to(list_path)
    end

    describe "notifications enabled" do

      before(:each) do
        # setup some relationships
        @following = create_list(:user, 2)
        @following.each do |following|
          @user.follow!(following)
        end
      end

      it "should send notifications" do
        RelationshipMailer.should_receive(:follower_notification).
          with(an_instance_of(User), @user).
          exactly(@following.size).times.
          and_return(double("mailer", deliver: true))

        post :notify, notify: "1"
      end

      it "should not re-deliver notifications to followed users" do
        # create new relationship but mark it as already having 
        # sent the notification
        relationship = @user.follow!(create(:user))
        relationship.delivered_notification_at = 3.days.ago
        relationship.save!

        # it should only deliver notifications for the relationships
        # that do not have delivered_notification_at set
        RelationshipMailer.should_receive(:follower_notification).
          with(an_instance_of(User), @user).
          exactly(@following.size).times.
          and_return(double("mailer", deliver: true))

        post :notify, notify: "1"
      end

    end

  end

end
