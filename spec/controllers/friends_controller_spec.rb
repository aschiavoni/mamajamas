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

    it "should assign fb friends" do
      get :index
      assigns(:fb_friends).should_not be_nil
    end

    it "should build relationships if never done before" do
      RelationshipBuilder.
        any_instance.
        should_receive(:build_relationships).
        with([])
      get :index
    end

    it "should not build relationships if done before" do
      user.relationships_created_at = Time.now.utc
      user.save!

      RelationshipBuilder.
        any_instance.
        should_not_receive(:build_relationships)
      get :index
    end

  end

  describe "notify" do

    it "should redirect to list" do
      post :notify
      response.should redirect_to(list_path)
    end

    describe "notifications enabled" do

      def mailer_jobs
        Sidekiq::Extensions::DelayedMailer.jobs
      end

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
        }.should change(mailer_jobs, :size).by(@following.size)
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
        }.should change(mailer_jobs, :size).by(@following.size)
      end

    end

  end

end
