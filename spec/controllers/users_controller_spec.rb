require 'spec_helper'

describe UsersController do

  let(:user) { create(:user) }

  before(:each) do
    sign_in user
  end

  describe "edit" do

    it "should get edit page" do
      get :edit
      response.should be_success
    end

    it "should create a UserProfile form object" do
      get :edit
      assigns(:profile).should be_an_instance_of(Forms::UserProfile)
    end

    it "should assign user" do
      get :edit
      assigns(:profile).user.should == user
    end

  end

  describe "update" do

    it "should redirect to profile after update" do
      Forms::UserProfile.any_instance.should_receive(:update!).and_return(true)
      put :update, user: { username: "test123" }
      response.should redirect_to(profile_path)
    end

    it "should render edit view if update fails" do
      Forms::UserProfile.any_instance.should_receive(:update!).and_return(false)
      put :update
      response.should render_template("edit")
    end

  end

end
