require 'spec_helper'

describe RegistrationsController do

  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe "register user" do

    it "should create user" do
      lambda {
        post :create, user: {
          username: "testuser",
          email: "testuser@domain.com",
          password: "p@ssw0rd!",
          password_confirmation: "p@ssw0rd!"
        }
      }.should change(User, :count).by(1)

    end

  end

  describe "facebook" do

    before(:each) do
      sign_in create(:user)
    end

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
