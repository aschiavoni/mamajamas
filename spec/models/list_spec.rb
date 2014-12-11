require 'spec_helper'

describe List, :type => :model do

  describe "title" do

    let(:user) {
      build(:user, first_name: "John", last_name: "Doe")
    }
    let(:list) { build(:list, title: nil, user: user) }

    let(:default_title) do
      "John#{Possessive::APOSTROPHE_CHAR}s baby registry"
    end

    it "should have a default title" do
      expect(list.title).to eq(default_title)
    end

    it "uses username in default title if first name not present" do
      u = build(:user, username: "testu", first_name: nil)
      l = build(:list, title: nil, user: u)
      default = "testu#{Possessive::APOSTROPHE_CHAR}s baby registry"
      expect(l.title).to eq(default)
    end

    it "uses List as default title if list does not have a user" do
      l = List.new
      expect(l.title).to eq("Baby registry")
    end

    it "should not overwrite title if it matches the default title" do
      list.title = default_title
      expect(list.read_attribute(:title)).to be_nil
    end

    it "should overwrite title" do
      list.title = "new title"
      expect(list.title).to eq("new title")
    end

    it "should default a blank title to the default title" do
      list.title = ""
      expect(list.title).to eq(default_title)
    end

  end

  describe "list with populated list item placeholders" do

    before(:all) do
      @list = create(:list)
      @product_types = [
        create(:product_type),
        create(:product_type),
        create(:product_type)
      ]
      @product_types.each do |product_type|
        @list.add_list_item_placeholder(product_type)
      end
    end

    it "should have many product types" do
      expect(@list.list_items.size).to eq(@product_types.size)
    end

    it "should include all product types" do
      @product_types.each do |product_type|
        expect(@list.list_items.map(&:product_type)).to include(product_type)
      end
    end

    it "should have categories" do
      # in the specs, each product_type has a unique category
      expect(@list.categories.size).to eq(@list.list_items.size)
    end

  end

  describe "add list item placeholder" do

    let(:list) { create(:list) }

    let(:product_type) { build(:product_type, recommended_quantity: 2) }

    it "should return a new list item" do
      list_item = list.add_list_item_placeholder(product_type)
      expect(list_item).to be_an_instance_of(ListItem)
    end

    it "should return a placeholder list item" do
      list_item = list.add_list_item_placeholder(product_type)
      expect(list_item.placeholder?).to be_truthy
    end

    it "should add the list item to the list" do
      expect do
        list.add_list_item_placeholder(product_type)
      end.to change(list.list_items, :count).by(1)
    end

    it "should have a list item with the correct product type" do
      list_item = list.add_list_item_placeholder(product_type)
      expect(list_item.product_type).to eq(product_type)
    end

    it "should have a list item with the correct category" do
      list_item = list.add_list_item_placeholder(product_type)
      expect(list_item.category).to eq(product_type.category)
    end

    it "should have a list item with the correct priority" do
      list_item = list.add_list_item_placeholder(product_type)
      expect(list_item.priority).to eq(product_type.priority)
    end

    it "should have a list item with the correct image url" do
      list_item = list.add_list_item_placeholder(product_type)
      expect(list_item.image_url).to eq(product_type.image_name)
    end

    it "should have a list item with the correct age range" do
      list_item = list.add_list_item_placeholder(product_type)
      expect(list_item.age_range).to eq(product_type.age_range)
    end

    it "should have a list item with the correct quantity" do
      list_item = list.add_list_item_placeholder(product_type)
      expect(list_item.desired_quantity).
        to(eq(product_type.recommended_quantity))
    end

  end

  describe "add list item" do

    let(:product_type) { create(:product_type) }

    let(:list) { create(:list) }

    it "should add a new list item" do
      expect do
        list.add_list_item(build(:list_item, list_id: nil))
      end.to change(list.list_items, :count).by(1)
    end

    it "should not add a placeholder by default" do
      list_item = list.add_list_item(build(:list_item, list_id: nil))
      expect(list_item).not_to be_placeholder
    end

    it "should add a placeholder list item" do
      list_item = list.add_list_item(build(:list_item, list_id: nil), true)
      expect(list_item).to be_placeholder
    end

  end

  describe "available product types" do

    let(:user) { create(:user) }

    let(:list) { create(:list, user: user) }

    before(:all) do
      @product_types = create_list(:product_type, 3)
    end

    it "should include global product types" do
      @product_types.each do |product_type|
        expect(list.available_product_types).to include(product_type)
      end
    end

    it "does not include inactive product types" do
      inactive = create(:product_type, active: false)
      expect(list.available_product_types).not_to include(inactive)
    end

    it "should only include product types with names matching filter" do
      name = "asdfg"
      product_type = create(:product_type, name: name)
      expect(list.available_product_types(name)).to include(product_type)
    end

    it "should not include product types with names not matching filter" do
      name = "asdfg"
      expect(list.available_product_types(name)).to be_empty
    end

    it "should limit the number of product types returned" do
      expect(list.available_product_types(nil, 1).size).to eq(1)
    end

  end

  describe "list entries" do

    before(:all) do
      ProductType.destroy_all
      @category = create(:category)
      @current_user = create(:user)
      @product_types = [
        create(:product_type),
        create(:product_type),
        create(:product_type)
      ]

      # create the list
      # and add some list items
      @list = @current_user.build_list!

      list_item_params = {
        list_id: @list.id,
        product_type_id: @product_types.first.id
      }
      @list_items = [
        create(:list_item, list_item_params.merge(category_id: @category.id)),
        create(:list_item, list_item_params),
        create(:list_item, list_item_params)
      ]
      @list.reload
    end

    it "should include all list entries" do
      expect(@list.list_entries.size).to eq(@list_items.size + @product_types.size)
    end

    it "should include all list items" do
      @list_items.each do |list_item|
        expect(@list.list_entries).to include(list_item)
      end
    end

    describe "filtered by category" do

      before(:all) do
        @filtered_list_items = @list_items.select do |list_item|
          list_item.category_id == @category.id
        end
      end

      it "should include only entries in category" do
        expect(@list.list_entries(@category).size).to eq(@filtered_list_items.size)
      end

      it "should include only list items in category" do
        @filtered_list_items.each do |list_item|
          expect(@list.list_entries(@category)).to include(list_item)
        end
      end

      it "should not include list items in other categories" do
        excluded = @list_items - @filtered_list_items
        excluded.each do |list_item|
          expect(@list.list_entries(@category)).not_to include(list_item)
        end
      end

    end

  end

  describe "shared list entries" do

    before(:all) do
      @current_user = create(:user)
      @list = @current_user.build_list!
      @list.add_list_item(build(:list_item, list_id: nil))
      @list.add_list_item(build(:list_item,
                                list_id: nil, owned: true))
    end

    it "has all user items shared when list is private" do
      @list.privacy = List::PRIVACY_PRIVATE
      expect(@list.shared_list_entries.count).to eq(
        @list.list_items.user_items.count
      )
    end

    it "has all user items shared when list is public" do
      @list.privacy = List::PRIVACY_PUBLIC
      expect(@list.shared_list_entries.count).to eq(
        @list.list_items.user_items.count
      )
    end

    it "has all user items shared when list is authenticated only" do
      @list.privacy = List::PRIVACY_REGISTERED
      expect(@list.shared_list_entries.count).to eq(
        @list.list_items.user_items.count
      )
    end

  end

  describe "view counts" do

    let(:list) { create(:list) }

    it "should increment view count" do
      expect do
        list.increment_view_count
        list.reload
      end.to change(list, :view_count).by(1)
    end

    it "should increment public view count" do
      expect do
        list.increment_public_view_count
        list.reload
      end.to change(list, :public_view_count).by(1)
    end

  end

  describe "has items" do

    let(:list) { create(:list) }

    it "indicates if a user has added any list items" do
      list_item = create(:list_item, list: list)
      expect(list).to have_items
    end

    it "indicates that user has not added any list items" do
      expect(list).not_to have_items
    end

  end

end
