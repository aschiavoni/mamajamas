require 'spec_helper'

describe Users::OmniauthCallbacksController do

  describe "facebook" do

    let(:auth_hash) {
      mock_facebook_omniauth('91234560', 'fbuser@example.com', 'Joseph', 'Case')
    }

    let(:oauth) {
      OmniauthHashParser.new(auth_hash)
    }

    before do
      ProfilePictureUploader.any_instance.stub(:download! => false)
    end

    before(:each) do
      request.env["devise.mapping"] = Devise.mappings[:user]
      request.env["omniauth.auth"] = auth_hash
    end

    describe "guest users" do
      let(:guest) { create(:user, guest: true) }

      it "updates a guest user from facebook" do
        sign_in guest
        get :facebook
        assigns(:user).should == guest
      end

      it "doesn't update guest user if a facebook user exists with uid" do
        u = create(:user)
        create(:authentication,
               user: u, uid: auth_hash.uid,
               provider: "facebook")
        sign_in guest
        AddsAuthentication.should_not_receive(:new)
        FacebookUserCreator.should_receive(:from_oauth) { u }
        get :facebook
      end

    end

    describe "html request" do

      it "should create user" do
        expect {
          get :facebook
        }.to change(User, :count).by(1)
      end

      it "should update facebook profile picture" do
        FacebookProfilePictureUpdater.any_instance.should_receive(:update!)
        get :facebook
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

      it "should update facebook profile picture" do
        FacebookProfilePictureUpdater.any_instance.should_receive(:update!)
        get :facebook
      end

      it "should render user json" do
        xhr :get, :facebook
        response.should render_template("facebook")
      end

    end

    describe "user creation fails" do

      before(:each) do
        FacebookUserCreator.should_receive(:from_oauth).and_return(build(:user))
      end

      describe "html request" do

        it "should redirect to new user registration url" do
          get :facebook
          response.should redirect_to(new_user_registration_url)
        end

      end

      describe "ajax request" do

        it "should render user json" do
          xhr :get, :facebook
          response.should render_template("facebook")
        end

      end

    end

  end

  describe "google" do

    let(:auth_hash) {
      mock_google_omniauth('91234560', 'googleuser@gmail.com', 'Joseph', 'Case')
    }

    before(:each) do
      request.env["devise.mapping"] = Devise.mappings[:user]
      request.env["omniauth.auth"] = auth_hash
    end

    describe "unauthenticated" do

      it "requires an authenticated user" do
        get :google
        response.should redirect_to(new_user_session_path)
      end

    end

    describe "authenticated" do

      let(:user) { create(:user) }

      before(:each) { sign_in user }

      it "returns a successful response" do
        get :google
        response.should redirect_to(new_friend_path(anchor: "gmailfriends"))
      end

      it "adds an authentication" do
        AddsAuthentication.any_instance.should_receive(:from_oauth)
        get :google
      end

    end

  end

end
