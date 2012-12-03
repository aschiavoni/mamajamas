require 'spec_helper'

describe FriendsController do

  describe "index" do

    before(:each) do
      sign_in create(:user)
    end

    it "should get friends list" do
      get :index
      response.should be_success
    end

  end

end
