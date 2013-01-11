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

end
