require 'spec_helper'

describe ListItemsController do

  let(:current_user) { create(:user) }
  let(:current_category) { create(:category) }

  before(:each) do
    sign_in current_user

    2.times do
      create(:product_type)
    end

  end

  describe "index" do

    describe "without category filter" do

      before(:each) do
        @list = current_user.list
        2.times do
          @list.list_items << create(:list_item, list_id: @list.id)
        end

        get :index
      end

      it "should assign list" do
        assigns(:list).should == @list
      end

      it "should use nil @category" do
        assigns(:category).should be_nil
      end

      it "should assign list entries" do
        assigns(:list_entries).size.should > 0
      end

      it "should create list entries for all list items and product types" do
        product_type_size = @list.product_types.size
        list_items_size = @list.list_items.size

        assigns(:list_entries).size.should == product_type_size + list_items_size
      end

    end

    describe "with category filter" do

      before(:each) do
        # create 2 new product types in current category
        2.times do
          create(:product_type, category_id: current_category.id)
        end

        @list = current_user.list
        2.times do
          @list.list_items << create(:list_item, list_id: @list.id, category_id: current_category.id)
        end

        get :index, category: current_category.id
      end

      it "should assign list" do
        assigns(:list).should == @list
      end

      it "should use assign category" do
        assigns(:category).should == current_category
      end

      it "should assign list entries" do
        assigns(:list_entries).size.should > 0
      end

      it "should create list entries for list items and product types in current category" do
        product_type_size = ProductType.where(category_id: current_category.id).size
        list_items_size = @list.list_items.where(category_id: current_category.id).size

        assigns(:list_entries).size.should == product_type_size + list_items_size
      end

    end

  end

  describe "create" do

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
        post :create, list_item: create_params
      end.should change(current_user.list.list_items, :count).by(1)
    end

    it "should assign list item" do
      post :create, list_item: create_params
      assigns(:list_item).should_not be_blank
    end

    it "should render json list item" do
      post :create, list_item: create_params, format: :json
      response.should render_template("create")
    end

  end

  describe "update" do

    let(:update_params) do
      {
        owned: true,
        rating: 3
      }
    end

    before(:each) do
      @list_item = create(:list_item, list_id: current_user.list.id, owned: false, rating: 1)
      put :update, id: @list_item.id, list_item: update_params
    end

    it "should assign list item" do
      assigns(:list_item).should == @list_item
    end

    it "should update list item owned" do
      assigns(:list_item).owned.should be_true
    end

    it "should update list item rating" do
      assigns(:list_item).rating.should == 3
    end

  end

  describe "destroy" do

    before(:each) do
      @list_item = create(:list_item, list_id: current_user.list.id, owned: false, rating: 1)
    end

    it "should assign list item" do
      delete :destroy, id: @list_item.id
      assigns(:list_item).should == @list_item
    end

    it "should delete list item" do
      lambda do
        delete :destroy, id: @list_item.id
      end.should change(current_user.list.list_items, :count).by(-1)
    end

  end

end
