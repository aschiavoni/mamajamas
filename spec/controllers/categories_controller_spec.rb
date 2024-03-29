require 'spec_helper'

describe CategoriesController, :type => :controller do

  describe "index" do

    let(:user) { create(:user) }

    before(:each) do
      sign_in user
    end

    it "should get json category listing" do
      get :index, format: :json
      expect(response).to be_success
    end

    it "should not get html category listing" do
      expect {
        get :index
      }.to raise_error(ActionController::RoutingError)
    end
  end
end
