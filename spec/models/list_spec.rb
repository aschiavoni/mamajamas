require 'spec_helper'

describe List do

  describe "title" do

    let(:list) { build(:list, title: nil) }

    let(:default_title) do
      "#{list.user.username.possessive} List"
    end

    it "should have a default title" do
      list.title.should == default_title
    end

    it "should not overwrite title if it matches the default title" do
      list.title = default_title
      list.read_attribute(:title).should be_nil
    end

    it "should overwrite title" do
      list.title = "new title"
      list.title.should == "new title"
    end

    it "should default a blank title to the default title" do
      list.title = ""
      list.title.should == default_title
    end

  end

  describe "list with populated list item placeholders" do

    let(:list) { create(:list) }

    let(:product_types) do
      [
        create(:product_type),
        create(:product_type),
        create(:product_type)
      ]
    end

    before(:all) do
      product_types.each do |product_type|
        list.add_list_item_placeholder(product_type)
      end
    end

    it "should have many product types" do
      list.list_items.size.should == product_types.size
    end

    it "should include all product types" do
      product_types.each do |product_type|
        list.list_items.map(&:product_type).should include(product_type)
      end
    end

    it "should have categories" do
      # in the specs, each product_type has a unique category
      list.categories.size.should == list.list_items.size
    end

  end

  describe "add list item placeholder" do

    let(:list) { create(:list) }

    let(:product_type) { build(:product_type) }

    it "should return a new list item" do
      list_item = list.add_list_item_placeholder(product_type)
      list_item.should be_an_instance_of(ListItem)
    end

    it "should return a placeholder list item" do
      list_item = list.add_list_item_placeholder(product_type)
      list_item.placeholder?.should be_true
    end

    it "should add the list item to the list" do
      lambda do
        list.add_list_item_placeholder(product_type)
      end.should change(list.list_items, :count).by(1)
    end

    it "should have a list item with the correct product type" do
      list_item = list.add_list_item_placeholder(product_type)
      list_item.product_type.should == product_type
    end

    it "should have a list item with the correct category" do
      list_item = list.add_list_item_placeholder(product_type)
      list_item.category.should == product_type.category
    end

    it "should have a list item with the correct priority" do
      list_item = list.add_list_item_placeholder(product_type)
      list_item.priority.should == product_type.priority
    end

    it "should have a list item with the correct image url" do
      list_item = list.add_list_item_placeholder(product_type)
      list_item.image_url.should == "/assets/products/icons/#{product_type.image_name}"
    end

    it "should have a list item with the correct when to buy suggestion" do
      list_item = list.add_list_item_placeholder(product_type)
      list_item.when_to_buy_suggestion.should == product_type.when_to_buy_suggestion
    end

  end

  describe "add list item" do

    let(:product_type) { create(:product_type) }

    let(:list) { create(:list) }

    it "should add a new list item" do
      lambda do
        list.add_list_item(build(:list_item, list_id: nil))
      end.should change(list.list_items, :count).by(1)
    end

  end

  describe "available product types" do

    let(:user) { create(:user) }

    let(:list) { create(:list, user: user) }

    before(:all) do
      ProductType.destroy_all
      @product_types = create_list(:product_type, 3)

      @list_product_type = create(:product_type)
      list.list_product_types << ListProductType.new({
        product_type: @list_product_type,
        category: @list_product_type.category
      })

      @hidden_list_product_type = create(:product_type)
      list.list_product_types << ListProductType.new({
        product_type: @hidden_list_product_type,
        category: @hidden_list_product_type.category,
        hidden: true
      })
    end

    it "should include global product types" do
      @product_types.each do |product_type|
        list.available_product_types.should include(product_type)
      end
    end

    it "should include owned product types" do
      user_product_type = create(:product_type)
      user.product_types << user_product_type

      list.available_product_types.should include(user_product_type)
    end

    it "should include hidden product types" do
      list.available_product_types.should include(@hidden_list_product_type)
    end

    it "should exclude product types in list" do
      list.available_product_types.should_not include(@list_product_type)
    end

  end

  describe "list entries" do

    let(:current_user) { create(:user) }

    let(:category) { create(:category) }

    before(:all) do
      ProductType.destroy_all
      @product_types = [
        create(:product_type),
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
      @list.reload
    end

    it "should include all list entries" do
      @list.list_entries.size.should == @list_items.size + @product_types.size
    end

    it "should include all list items" do
      @list_items.each do |list_item|
        @list.list_entries.should include(list_item)
      end
    end

    describe "filtered by category" do

      before(:all) do
        @filtered_list_items = @list_items.select do |list_item|
          list_item.category_id == category.id
        end
      end

      it "should include only entries in category" do
        @list.list_entries(category).size.should == @filtered_list_items.size
      end

      it "should include only list items in category" do
        @filtered_list_items.each do |list_item|
          @list.list_entries(category).should include(list_item)
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
