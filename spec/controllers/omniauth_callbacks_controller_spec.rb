require 'spec_helper'

describe Users::OmniauthCallbacksController, super: true do

  describe "facebook" do

    before(:each) do
      mock_omniauth
      request.env["devise.mapping"] = Devise.mappings[:user]
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
    end

    describe "html request" do

      it "should create user" do
        expect {
          get :facebook
        }.to change(User, :count).by(1)
      end

      it "should redirect to registrations facebook path" do
        get :facebook
        response.should redirect_to registrations_facebook_path
      end

    end

    describe "ajax request" do

      it "should create user" do
        expect {
          xhr :get, :facebook
        }.to change(User, :count).by(1)
      end

      it "should render user json" do
        xhr :get, :facebook
        response.should render_template("facebook")
      end

    end

  end

end
