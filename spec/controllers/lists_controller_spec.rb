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

end
