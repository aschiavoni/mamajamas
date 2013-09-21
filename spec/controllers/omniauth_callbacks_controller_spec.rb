require 'spec_helper'

describe Users::OmniauthCallbacksController do

  describe "facebook" do

    let(:auth_hash) {
      mock_facebook_omniauth('91234560', 'fbuser@example.com', 'Joseph', 'Case')
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
        User.any_instance.should_receive(:add_facebook_uid!).
          with(auth_hash['uid'])
        get :facebook
      end

      it "doesn't update guest user if a facebook user exists with uid" do
        create(:user, uid: auth_hash['uid'], provider: 'facebook')
        sign_in guest
        User.any_instance.should_not_receive(:add_facebook_uid!)
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

end
