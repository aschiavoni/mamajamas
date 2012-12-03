require 'spec_helper'

describe CategoriesController do

  describe "index" do

    before(:each) do
      sign_in create(:user)
    end

    it "should get json category listing" do
      get :index, format: :json
      response.should be_success
    end

    it "should not get html category listing" do
      expect {
        get :index
      }.to raise_error(ActionController::RoutingError)
    end
  end
end
