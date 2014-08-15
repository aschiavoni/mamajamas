require 'spec_helper'

describe ListItemsController, type: :controller do

  before(:all) do
    @current_category = create(:category)
    @current_user = create(:user)
    @list = @current_user.build_list!
  end

  before(:each) do
    sign_in @current_user
  end

  describe "index" do

    before(:all) do
      2.times do
        create(:product_type)
      end
    end

    describe "without category filter" do

      before(:all) do
        2.times do
          @list.list_items << create(:list_item, list_id: @list.id)
        end
      end

      before(:each) { get :index, format: :json }

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
        list_items_size = @list.list_items.size

        assigns(:list_entries).size.should == list_items_size
      end

    end

    describe "with category filter" do

      before(:all) do
        @my_category = create(:category)
        # create 2 new product types in current category
        2.times do
          create(:product_type, category_id: @my_category.id)
        end

        2.times do
          @list.list_items << create(:list_item, list_id: @list.id, category_id: @my_category.id)
        end
      end

      before(:each) do
        get :index, category: @my_category.id, format: :json
      end

      it "should assign list" do
        assigns(:list).should == @list
      end

      it "should use assign category" do
        assigns(:category).should == @my_category
      end

      it "should assign list entries" do
        assigns(:list_entries).size.should > 0
      end

      it "should create list entries for list items and product types in current category" do
        list_items_size = @list.list_items.where(category_id: @my_category.id).size

        assigns(:list_entries).size.should == list_items_size
      end

    end

  end

  describe "create" do

    context "list item" do

      let(:product_type) { create(:product_type) }
      let(:age_range) { create(:age_range, name: 'Pre-Birth') }

      let(:create_params) do
        {
          name: "some new product",
          owned: false,
          link: "http://domain.com/newproduct",
          rating: 3,
          age: "Pre-Birth",
          age_range_id: age_range.id,
          priority: 2,
          notes: "these are notes",
          image_url: "http://domain.com/newproduct.png",
          category_id: @current_category.id,
          product_type_id: product_type.id,
          product_type_name: product_type.name,
          placeholder: false
        }
      end

      it "should create list item" do
        lambda do
          post :create, list_item: create_params, format: :json
        end.should change(@list.list_items, :count).by(1)
      end

      it "should assign list entry" do
        post :create, list_item: create_params, format: :json
        assigns(:list_entry).should_not be_blank
      end

      it "list entry should be a list item" do
        post :create, list_item: create_params, format: :json
        assigns(:list_entry).should be_kind_of(ListItem)
      end

      it "should create a list item placeholder" do
        post :create, list_item: create_params.merge(placeholder: true), format: :json
        assigns(:list_entry).should be_placeholder
      end

      it "should render json list item" do
        post :create, list_item: create_params, format: :json
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
      list_item = @list.list_items.first
      list_item.update_attributes!(owned: false, rating: 1, recommended: true)
      list_item
    end

    before(:each) do
      put :update, id: list_item.id, list_item: update_params, format: :json
    end

    it "should assign list entry" do
      assigns(:list_entry).should == list_item
    end

    it "should update list entry owned" do
      assigns(:list_entry).owned.should be_truthy
    end

    it "should update list item rating" do
      assigns(:list_entry).rating.should == 3
    end

    it "should clear list item recommended flag" do
      assigns(:list_entry).should_not be_recommended
    end

  end

  describe "destroy" do

    before(:all) do
      # this will be added to the list when it is created
      @product_type = create(:product_type)
      @list_item = create(:list_item, list_id: @list.id, owned: false, rating: 1)
    end

    it "should assign list entry" do
      delete :destroy, id: @list_item.id, format: :json
      assigns(:list_entry).should == @list_item
    end

    it "should delete list item" do
      lambda do
        delete :destroy, id: @list_item.id, format: :json
      end.should change(@list.list_items, :count).by(-1)
    end

  end
end
