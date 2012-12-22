require 'spec_helper'

describe ProductTypesController do

  describe "index" do

    let(:user) { create(:user) }

    before(:each) do
      sign_in user
    end

    it "should get json product types" do
      get :index, category_id: create(:category).id, format: :json
      response.should be_success
    end

    it "should not get html product types" do
      expect {
        get :index, category_id: create(:category).id
      }.to raise_error(ActionController::RoutingError)
    end

  end

end
