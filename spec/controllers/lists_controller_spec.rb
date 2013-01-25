require 'spec_helper'

describe ListsController do

  let(:user) { create(:user) }

  before(:each) do
    sign_in user
  end

  describe "show" do

    it "should get list page" do
      get :show
      response.should be_success
    end

  end

  describe "product types" do

    it "should call available product types" do
      List.any_instance.
        should_receive(:available_product_types).
        with("filter", 20).and_return([])

      get :product_types, format: :json, filter: "filter"
    end

  end

end
