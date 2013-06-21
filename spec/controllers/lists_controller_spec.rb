require 'spec_helper'

describe ListsController do

  let(:user) { create(:user) }

  describe "show" do

    context "with list" do

      before(:each) do
        user.build_list!
      end

      before(:each) do
        sign_in user
      end

      it "should get list page" do
        get :show
        response.should be_success
      end

      it "should increment view count" do
        List.any_instance.should_receive(:increment_view_count)
        get :show
      end

    end

    context "without list" do

      it "should redirect to quiz if list doesn't exist" do
        u = create(:user)
        sign_in u
        get :show
        response.should redirect_to(quiz_path)
      end

    end

  end

  describe "product types" do

    before(:each) do
      sign_in user
    end

    before(:each) do
      user.build_list!
    end

    it "should call available product types" do
      List.any_instance.
        should_receive(:available_product_types).
        with("filter", 20).and_return([])

      get :product_types, format: :json, filter: "filter"
    end

  end

  describe "suggestions" do

    before(:each) do
      sign_in user
    end

    it "lists all product type suggestions" do
      CachedProductTypeSuggestions.should_receive(:find).
        exactly(ProductType.scoped.count).times

      get :suggestions, format: :json
    end

    it "lists product type suggestions for specific category" do
      category = create(:category)
      product_types = create_list(:product_type, 3, category: category)

      CachedProductTypeSuggestions.should_receive(:find).
        exactly(category.product_types.count).times

      get :suggestions, category: category.slug, format: :json
    end


  end

end
