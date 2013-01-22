require 'spec_helper'

describe ListEntriesController do

  let (:current_user) { create(:user) }
  let (:current_category) { create(:category) }

  before(:each) do
    sign_in current_user
  end

  describe "create" do

    context "list item" do

      let(:create_params) do
        {
          name: "some new product",
          owned: false,
          link: "http://domain.com/newproduct",
          rating: 3,
          when_to_buy: "Pre-Birth",
          priority: 2,
          notes: "these are notes",
          image_url: "http://domain.com/newproduct.png",
          category_id: current_category.id,
          product_type_id: create(:product_type).id
        }
      end

      it "should create list item" do
        lambda do
          post :create, list_entry: create_params
        end.should change(current_user.list.list_items, :count).by(1)
      end

      it "should assign list entry" do
        post :create, list_entry: create_params
        assigns(:list_entry).should_not be_blank
      end

      it "list entry should be a list item" do
        post :create, list_entry: create_params
        assigns(:list_entry).should be_kind_of(ListItem)
      end

      it "should render json list item" do
        post :create, list_entry: create_params, format: :json
        response.should render_template("create")
      end

    end

  end

  describe "update" do

    let(:update_params) do
      {
        owned: true,
        rating: 3
      }
    end

    let(:list_item) do
      create(:list_item, list_id: current_user.list.id, owned: false, rating: 1)
    end

    before(:each) do
      put :update, id: list_item.id, list_entry: update_params
    end

    it "should assign list entry" do
      assigns(:list_entry).should == list_item
    end

    it "should update list entry owned" do
      assigns(:list_entry).owned.should be_true
    end

    it "should update list item rating" do
      assigns(:list_entry).rating.should == 3
    end

  end

  describe "destroy" do

    before(:all) do
      # this will be added to the list when it is created
      @product_type = create(:product_type)
      @list_item = create(:list_item, list_id: current_user.list.id, owned: false, rating: 1)
    end

    it "should assign list entry" do
      delete :destroy, id: @list_item.id
      assigns(:list_entry).should == @list_item
    end

    it "should delete list item" do
      lambda do
        delete :destroy, id: @list_item.id
      end.should change(current_user.list.list_items, :count).by(-1)
    end

  end

end
