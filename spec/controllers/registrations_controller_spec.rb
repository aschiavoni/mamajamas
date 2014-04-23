require 'spec_helper'

describe RegistrationsController do

  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe "register user" do

    let(:user) { build(:user) }

    let(:registration) do
      {
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

    it "should send confirmation email for new user" do
      lambda {
        post :create, user: registration
      }.should change(ActionMailer::Base.deliveries, :size).by(1)
    end

    it "should create guest user" do
      user_stub = stub(:persisted? => true)
      User.should_receive(:new_guest).and_return(user_stub)
      RegistrationsController.any_instance.should_receive(:sign_in).
        with(:user, user_stub)

      post :create
    end

    it "should not send confirmation email for new guest user" do
      lambda {
        post :create
      }.should_not change(ActionMailer::Base.deliveries, :size)
    end

    it "redirects to quiz when guest user is created" do
      User.should_receive(:new_guest).and_return(stub(:persisted? => true))
      RegistrationsController.any_instance.should_receive(:sign_in)

      post :create
      response.should redirect_to(quiz_path)
    end

    it "redirects to signup when guest user cannot be created" do
      User.should_receive(:new_guest).and_return(stub(:persisted? => false))
      post :create
      response.should redirect_to(new_user_registration_path)
    end

    # this is testing devise functionality but I am dependent on it
    it "should incremement sign in count" do
      post :create, user: registration
      assigns(:user).sign_in_count.should == 1
    end

    it "redirects to friends path after signup" do
      post :create, user: registration
      response.should redirect_to(friends_path)
    end

  end

end
