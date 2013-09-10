require 'spec_helper'

describe FriendsController do

  let(:user) { create(:user) }

  before(:each) do
    sign_in user
  end

  describe "index" do

    it "should get friends list" do
      get :index
      response.should be_success
    end

    it "should assign friends" do
      get :index
      assigns(:friends).should_not be_nil
    end

  end

end
