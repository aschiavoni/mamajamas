require 'spec_helper'

describe ListsController, :type => :controller do

  let(:user) { create(:user) }

  describe "show" do

    context "never taken quiz" do

      let(:user_no_quiz) { create(:user, quiz_taken_at: nil) }

      before(:each) { sign_in user_no_quiz }

      it "redirects to quiz" do
        get :show
        expect(response).to redirect_to(quiz_path)
      end

    end

    context "with list" do

      before(:each) do
        user.build_list!.complete!
      end

      before(:each) do
        sign_in user
      end

      it "should get list page" do
        get :show
        expect(response).to be_success
      end

      it "should increment view count" do
        expect_any_instance_of(List).to receive(:increment_view_count)
        get :show
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
      expect_any_instance_of(List).
        to receive(:available_product_types).
        with("filter", 20).and_return([])

      get :product_types, format: :json, filter: "filter"
    end

  end

end
