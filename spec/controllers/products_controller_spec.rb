require 'spec_helper'

describe ProductsController, :type => :controller do

  describe "index" do

    let(:category) { create(:category) }

    let(:product_type) { create(:product_type, category: category) }

    let(:user) { create(:user) }

    before(:each) do
      sign_in user
      Rails.cache.clear
    end

    it "should get json product listing" do
      get :index, format: :json
      expect(response).to be_success
    end

    it "returns empty hash when query is not found" do
      get :index, format: :json
      expect(response.body).to eq("")
    end

    it "searches for specified filter" do
      filter = "baby bottle"
      expect(ProductSearcher).to receive(:search).with(filter, anything(), anything())
      get :index, filter: filter, format: :json
    end

    it "searches for filter + name" do
      filter = "medela product"
      name = "Bottle"
      expect(ProductSearcher).to receive(:search).
        with("#{filter} #{name.downcase}", anything, anything)
      get :index, filter: filter, name: name, format: :json
    end

    it "does not append product type name if filter == name" do
      filter = "bottle"
      name = "Bottle"
      expect(ProductSearcher).to receive(:search).
        with("#{filter}", anything, anything)
      get :index, filter: filter, name: name, format: :json
    end

    it "does not append product type name if filter >= 3 words" do
      filter = "bottle large white"
      name = "Bottle"
      expect(ProductSearcher).to receive(:search).
        with("#{filter}", anything, anything)
      get :index, filter: filter, name: name, format: :json
    end

    it "should not get html product listing" do
      expect {
        get :index, filter: "filter"
      }.to raise_error(ActionController::RoutingError)
    end

  end

end
