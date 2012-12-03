require 'spec_helper'

describe HomeController do

  describe "index" do

    before(:each) do
      sign_in create(:user)
    end

    it "should get home page" do
      get :index
      response.should be_success
    end

  end

end
