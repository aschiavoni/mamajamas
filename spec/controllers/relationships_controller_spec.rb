require 'spec_helper'

describe RelationshipsController do

  let(:current_user) { create(:user) }
  let(:user_to_follow) { create(:user) }

  describe "create relationship" do

    before(:each) do
      sign_in current_user
    end

    it "should assign friend" do
      post :create, relationship: { followed_id: user_to_follow.id }
      assigns(:friend).should == user_to_follow
    end

    it "should create following relationship" do
      post :create, relationship: { followed_id: user_to_follow.id }
      current_user.should be_following(user_to_follow)
    end

    it "should create follower relationship" do
      post :create, relationship: { followed_id: user_to_follow.id }
      user_to_follow.followers.should include(current_user)
    end

    it "should render friend template" do
      post :create, relationship: { followed_id: user_to_follow.id }
      response.should render_template("friends/_friend")
    end

    it "sends notification email" do
      lambda {
        post :create, relationship: { followed_id: user_to_follow.id }
      }.should change(ActionMailer::Base.deliveries, :size).by(1)
    end

    it "does not send notification email if it has already been sent" do
      current_user.relationships.create({
        followed_id: user_to_follow.id,
        delivered_notification_at: Time.now.utc
      }, { without_protection: true })
      lambda {
        post :create, relationship: { followed_id: user_to_follow.id }
      }.should_not change(ActionMailer::Base.deliveries, :size)
    end

    it "does not send notification email if no notification flag set" do
      new_user = create(:user)
      lambda {
        post :create, no_notification: "1", relationship: { followed_id: new_user.id }
      }.should_not change(ActionMailer::Base.deliveries, :size)
    end
  end

  describe "destroy relationship" do

    before(:each) do
      sign_in current_user
      relationship = current_user.follow!(user_to_follow)
      delete :destroy, id: relationship.id
    end

    it "should assign friend" do
      assigns(:friend).should == user_to_follow
    end

    it "should destroy following relationship" do
      current_user.should_not be_following(user_to_follow)
    end

    it "should destroy follower relationship" do
      user_to_follow.followers.should_not include(current_user)
    end

    it "should render friend template" do
      response.should render_template("friends/_friend")
    end

  end
end
