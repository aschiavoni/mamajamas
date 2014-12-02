require 'spec_helper'

describe RegistrationsController, :type => :controller do

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
      expect {
        post :create, user: registration
      }.to change(User, :count).by(1)
    end

    it "should send confirmation email for new user" do
      expect {
        post :create, user: registration
      }.to change(ActionMailer::Base.deliveries, :size).by(1)
    end

    it "should create guest user" do
      user_stub = double(:persisted? => true)
      expect(User).to receive(:new_guest).and_return(user_stub)
      expect_any_instance_of(RegistrationsController).to receive(:sign_in).
        with(:user, user_stub)

      post :create
    end

    it "should not send confirmation email for new guest user" do
      expect {
        post :create
      }.not_to change(ActionMailer::Base.deliveries, :size)
    end

    it "redirects to quiz when guest user is created" do
      expect(User).to receive(:new_guest).and_return(double(:persisted? => true))
      expect_any_instance_of(RegistrationsController).to receive(:sign_in)

      post :create
      expect(response).to redirect_to(quiz_path)
    end

    it "redirects to signup when guest user cannot be created" do
      expect(User).to receive(:new_guest).and_return(double(:persisted? => false))
      post :create
      expect(response).to redirect_to(new_user_registration_path)
    end

    # this is testing devise functionality but I am dependent on it
    it "should incremement sign in count" do
      post :create, user: registration
      expect(assigns(:user).sign_in_count).to eq(1)
    end

    it "redirects to registry setting after signup" do
      post :create, user: registration
      expect(response).to redirect_to(registry_path)
    end

  end

end
