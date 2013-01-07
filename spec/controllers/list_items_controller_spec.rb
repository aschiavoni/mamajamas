require 'spec_helper'

describe ListItemsController do

  let(:current_user) { create(:user) }
  let(:current_category) { create(:category) }

  before(:all) do
    2.times do
      create(:product_type)
    end
  end

  before(:each) do
    sign_in current_user
  end

  describe "index" do

    describe "without category filter" do

      before(:all) do
        @list = current_user.list
        2.times do
          @list.list_items << create(:list_item, list_id: @list.id)
        end
      end

      before(:each) { get :index }

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

      before(:all) do
        # create 2 new product types in current category
        2.times do
          create(:product_type, category_id: current_category.id)
        end

        @list = current_user.list
        2.times do
          @list.list_items << create(:list_item, list_id: @list.id, category_id: current_category.id)
        end
      end

      before(:each) do
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

end
