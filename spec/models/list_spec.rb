require 'spec_helper'

describe List do

  describe "list with populated product types" do

    let(:list) { create(:list) }

    let(:product_types) do
      [
        create(:product_type),
        create(:product_type)
      ]
    end

    before(:each) do
      product_types.each do |product_type|
        list.list_product_types << ListProductType.new({
          product_type: product_type,
          category: product_type.category
        })
      end
    end

    it "should have many product types" do
      product_types.size.should == list.product_types.size
    end

    it "should include all product types" do
      product_types.each do |product_type|
        list.product_types.should include(product_type)
      end
    end

    it "should have categories" do
      # in the specs, each product_type has a unique category
      list.categories.size.should == product_types.size
    end
  end

  describe "list entries" do

    let(:current_user) { create(:user) }
    let(:category) { create(:category) }

    before(:each) do
      @product_types = [
        create(:product_type, category_id: category.id),
        create(:product_type),
        create(:product_type)
      ]

      # create the list
      # and add some list items
      @list = current_user.list

      list_item_params = {
        list_id: @list.id,
        product_type_id: @product_types.first.id
      }
      @list_items = [
        create(:list_item, list_item_params.merge(category_id: category.id)),
        create(:list_item, list_item_params),
        create(:list_item, list_item_params)
      ]
    end

    it "should include all list entries" do
      @list.list_entries.size.should == ProductType.count + @list_items.size
    end

    it "should include all product types" do
      @product_types.each do |product_type|
        @list.list_entries.should include(product_type)
      end
    end

    it "should include all list items" do
      @list_items.each do |list_item|
        @list.list_entries.should include(list_item)
      end
    end

    describe "filtered by category" do

      before(:each) do
        @filtered_product_types = @product_types.select do |product_type|
          product_type.category_id == category.id
        end

        @filtered_list_items = @list_items.select do |list_item|
          list_item.category_id == category.id
        end
      end

      it "should include only entries in category" do
        @list.list_entries(category).size.should == @filtered_product_types.size + @filtered_list_items.size
      end

      it "should include only product types in category" do
        @filtered_product_types.each do |product_type|
          @list.list_entries(category).should include(product_type)
        end
      end

      it "should include only list items in category" do
        @filtered_list_items.each do |list_item|
          @list.list_entries(category).should include(list_item)
        end
      end

      it "should not include product types in other categories" do
        excluded = @product_types - @filtered_product_types
        excluded.each do |product_type|
          @list.list_entries(category).should_not include(product_type)
        end
      end

      it "should not include list items in other categories" do
        excluded = @list_items - @filtered_list_items
        excluded.each do |list_item|
          @list.list_entries(category).should_not include(list_item)
        end
      end

    end

  end

end
