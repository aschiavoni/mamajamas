require 'spec_helper'

describe ProductsController do

  describe "index" do

    let(:category) { create(:category) }

    let(:product_type) { create(:product_type, category: category) }

    before(:each) do
      sign_in create(:user)
    end

    it "should get json product listing" do
      get :index, category_id: category.id, product_type_id: product_type.id, format: :json
      response.should be_success
    end

    it "should not get html product listing" do
      expect {
        get :index, category_id: category.id, product_type_id: product_type.id
      }.to raise_error(ActionController::RoutingError)
    end

  end

end
