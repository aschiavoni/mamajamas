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

    it "should have a list item with the correct age range" do
      list_item = list.add_list_item_placeholder(product_type)
      list_item.age_range.should == product_type.age_range
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

    it "should not add a placeholder by default" do
      list_item = list.add_list_item(build(:list_item, list_id: nil))
      list_item.should_not be_placeholder
    end

    it "should add a placeholder list item" do
      list_item = list.add_list_item(build(:list_item, list_id: nil), true)
      list_item.should be_placeholder
    end

    it "new list items should not be shared" do
      list_item = list.add_list_item(build(:list_item, list_id: nil))
      list_item.should_not be_shared
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
        list.available_product_types.should include(product_type)
      end
    end

    it "should only include product types with names matching filter" do
      name = "asdfg"
      product_type = create(:product_type, name: name)
      list.available_product_types(name).should include(product_type)
    end

    it "should not include product types with names not matching filter" do
      name = "asdfg"
      list.available_product_types(name).should be_empty
    end

    it "should limit the number of product types returned" do
      list.available_product_types(nil, 1).size.should == 1
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
      @list = current_user.build_list!

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

  describe "sharing" do

    let(:list) { create(:list) }
    let(:product_type) { create(:product_type) }

    it "should not be public by default" do
      list.should_not be_public
    end

    it "shares list and marks it as public" do
      list.share_public!
      list.reload
      list.should be_public
    end

    it "marks all items in list as shared when list is shared" do
      list.should_receive(:share_all_list_items!)
      list.share_public!
    end

    it "should unshare list and mark it as not public" do
      list.share_public!
      list.reload
      list.unshare_public!
      list.reload
      list.should_not be_public
    end

    it "marks all items in list as not shared when list is unshared" do
      list.should_receive(:unshare_all_list_items!)
      list.unshare_public!
    end

    context "share all list items" do

      before(:each) do
        list.add_list_item_placeholder(product_type)
        list.add_list_item(build(:list_item, list_id: nil))
        list.share_all_list_items!
      end

      it "shares all user items" do
        list.list_items.user_items.map(&:shared).uniq.should == [ true ]
      end

      it "does not share placeholders" do
        list.list_items.placeholders.map(&:shared).uniq.should == [ false ]
      end

    end

    context "unshare all list items" do

      before(:each) do
        list.add_list_item_placeholder(product_type)
        list.add_list_item(build(:list_item, list_id: nil, shared: true))
      end

      it "unshares all user items" do
        list.unshare_all_list_items!
        list.list_items.user_items.map(&:shared).uniq.should == [ false ]
      end

    end

  end

  describe "view counts" do

    let(:list) { create(:list) }

    it "should increment view count" do
      lambda do
        list.increment_view_count
      end.should change(list, :view_count).by(1)
    end

    it "should increment public view count" do
      lambda do
        list.increment_public_view_count
      end.should change(list, :public_view_count).by(1)
    end

  end

  describe "has items" do

    let(:list) { create(:list) }

    it "indicates if a user has added any list items" do
      list_item = create(:list_item, list: list)
      list.should have_items
    end

    it "indicates that user has not added any list items" do
      list.should_not have_items
    end

  end

end
