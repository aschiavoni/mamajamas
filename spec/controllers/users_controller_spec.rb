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

    it "should find user" do
      get :edit
      assigns(:user).should == user
    end

  end

end
