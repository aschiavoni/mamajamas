require 'spec_helper'

describe RegistrationsController do

  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe "register user" do

    let(:user) { build(:user) }

    let(:registration) do
      {
        username: user.username,
        email: user.email,
        password: "p@ssw0rd!",
        password_confirmation: "p@ssw0rd!"
      }
    end

    it "should create user" do
      lambda {
        post :create, user: registration
      }.should change(User, :count).by(1)

    end

    # this is testing devise functionality but I am dependent on it
    it "should incremement sign in count" do
      post :create, user: registration
      assigns(:user).sign_in_count.should == 1
    end

  end

  describe "facebook" do

    before(:each) do
      sign_in create(:user)
    end

    describe "path" do

      before(:each) { get :facebook }

      it "should render view" do
        response.should be_success
      end

      it "should render view" do
        response.should render_template("facebook")
      end

    end

    describe "updating username" do

      it "should redirect to friends path" do
        put :facebook, user: {
          username: "facebookusername"
        }

        response.should redirect_to(friends_path)
      end

      it "should render view when username is invalid" do
        put :facebook, user: {
          username: nil
        }

        response.should render_template("facebook")
      end

    end

  end

end
