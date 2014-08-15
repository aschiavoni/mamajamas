require 'spec_helper'

describe RelationshipsController, :type => :controller do

  let(:current_user) { create(:user) }
  let(:user_to_follow) { create(:user) }

  describe "create relationship" do

    before(:each) do
      sign_in current_user
    end

    it "should assign friend" do
      post :create, relationship: { followed_id: user_to_follow.id }
      expect(assigns(:friend)).to eq(user_to_follow)
    end

    it "should create following relationship" do
      post :create, relationship: { followed_id: user_to_follow.id }
      expect(current_user).to be_following(user_to_follow)
    end

    it "should create follower relationship" do
      post :create, relationship: { followed_id: user_to_follow.id }
      expect(user_to_follow.followers).to include(current_user)
    end

    it "should render list friend template" do
      post :create, relationship: { followed_id: user_to_follow.id }
      expect(response).to render_template("friends/_list_friend")
    end

    it "sends notification email" do
      expect {
        post :create, relationship: { followed_id: user_to_follow.id }
      }.to change(ActionMailer::Base.deliveries, :size).by(1)
    end

    it "does not send notification email if it has already been sent" do
      current_user.relationships.create({
        followed_id: user_to_follow.id,
        delivered_notification_at: Time.now.utc
      }, { without_protection: true })
      expect {
        post :create, relationship: { followed_id: user_to_follow.id }
      }.not_to change(ActionMailer::Base.deliveries, :size)
    end

    it "does not send notification email if no notification flag set" do
      new_user = create(:user)
      expect {
        post :create, no_notification: "1", relationship: { followed_id: new_user.id }
      }.not_to change(ActionMailer::Base.deliveries, :size)
    end
  end

  describe "destroy relationship" do

    before(:each) do
      sign_in current_user
      relationship = current_user.follow!(user_to_follow)
      delete :destroy, id: relationship.id
    end

    it "should assign friend" do
      expect(assigns(:friend)).to eq(user_to_follow)
    end

    it "should destroy following relationship" do
      expect(current_user).not_to be_following(user_to_follow)
    end

    it "should destroy follower relationship" do
      expect(user_to_follow.followers).not_to include(current_user)
    end

    it "should render list friend template" do
      expect(response).to render_template("friends/_list_friend")
    end

  end
end
