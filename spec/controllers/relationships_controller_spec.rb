require 'spec_helper'

describe RelationshipsController do

  let(:current_user) { create(:user) }
  let(:user_to_follow) { create(:user) }

  describe "create relationship" do

    before(:each) do
      sign_in current_user
      post :create, relationship: { followed_id: user_to_follow.id }
    end

    it "should assign friend" do
      assigns(:friend).should == user_to_follow
    end

    it "should create following relationship" do
      current_user.should be_following(user_to_follow)
    end

    it "should create follower relationship" do
      user_to_follow.followers.should include(current_user)
    end

    it "should render friend template" do
      response.should render_template("friends/_friend")
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
