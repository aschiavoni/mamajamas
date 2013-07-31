require 'spec_helper'

describe ProductType do

  describe "global" do

    it "should include global product types" do
      global_product_type = create(:product_type)
      ProductType.global.should include(global_product_type)
    end

    it "should only include global product types" do
      user_product_type = create(:product_type, user: create(:user))
      ProductType.global.should_not include(user_product_type)
    end

  end

  describe "user" do

    it "should include user product types" do
      user_product_type = create(:product_type, user: create(:user))
      ProductType.user.should include(user_product_type)
    end

    it "should only include user product types" do
      global_product_type = create(:product_type)
      ProductType.user.should_not include(global_product_type)
    end

  end

  describe "available products" do

    let(:product_type) { build(:product_type) }

    it "should return active products for product type" do
      active_products = [ stub ]
      product_type.stub_chain(:products, :active).and_return(active_products)
      product_type.available_products.should == active_products
    end

    it "should return all active products for product type without products" do
      product_type.stub_chain(:products, :active).and_return([])
      Product.should_receive(:active)
      product_type.available_products
    end
  end

  describe "by category" do

    it "should query by category if specified" do
      category = stub(:category, id: 1)
      subject.class.should_receive(:where).with(category_id: category.id)
      subject.class.by_category(category)
    end

    it "should not filter results if category is blank" do
      subject.class.should_receive(:scoped)
      subject.class.by_category(nil)
    end

  end

  describe "image name" do

    it "should return image name" do
      pt = build(:product_type, image_name: "test.png")
      pt.image_name.should == "test.png"
    end

    it "should return unknown image name when image name is blank" do
      pt = build(:product_type, image_name: nil)
      pt.image_name.should == "unknown.png"
    end

  end

  describe "when to buy" do

    let(:age_range) { create(:age_range) }

    it "should return age range name" do
      pt = build(:product_type, age_range: age_range)
      pt.age.should == age_range.name
    end

    it "should set age range from name" do
      pt = build(:product_type)
      AgeRange.should_receive(:find_by_name).with(age_range.name).and_return(age_range)
      pt.age = age_range.name
      pt.age.should == age_range.name
    end

    it "should not change age range with an unknown name" do
      pt = build(:product_type)
      lambda do
        pt.age = "unknown"
      end.should_not change(pt, :age)
    end

  end

  describe "products" do

    before(:all) do
      @product_type = create(:product_type)
      @products = create_list(:product, 3)

      @products.each do |product|
        @product_type.products << product
      end
    end

    it "should return all products" do
      @product_type.products.size.should == @products.size
    end

    it "should include all products" do
      @products.each do |product|
        @product_type.products.should include(product)
      end
    end

  end

  describe "product type queries" do

    before(:all) do
      @product_type = create(:product_type)
      @product_type_queries = create_list(:product_type_query, 3, product_type: @product_type)
    end

    it "should have many product type queries" do
      @product_type.queries.size.should == @product_type_queries.size
    end

  end

  describe "queries" do

    before(:all) do
      @product_type = create(:product_type)
      @included_query = create(:product_type_query, product_type: @product_type)
      @excluded_query = create(:product_type_query)
    end

    it "has query" do
      @product_type.has_query?(@included_query.query).should be_true
    end

    it "does not have query" do
      @product_type.has_query?(@excluded_query.query).should be_false
    end

    it "adds a query that does not already exist" do
      lambda do
        @product_type.add_query('some stuff')
      end.should change(@product_type.queries, :count).by(1)
    end

    it "doesn't add a query that exist" do
      query_name = @included_query.query
      lambda do
        @product_type.add_query(query_name)
      end.should_not change(@product_type.queries, :count)
    end

  end

  describe "admin_deleteable?" do

    it "can be deleted" do
      product_type = build(:product_type)
      product_type.should be_admin_deleteable
    end

    it "can't be deleted if there are list items that use it" do
      product_type = build(:product_type)
      list_item = create(:list_item, product_type: product_type)
      product_type.should_not be_admin_deleteable
    end

    it "can't be deleted if it is owned by a user" do
      product_type = build(:product_type, user: build(:user))
      product_type.list_items << build(:list_item)
      product_type.should_not be_admin_deleteable
    end

    it "can't be deleted if there are associated products" do
      product_type = create(:product_type)
      product_type.products << create(:product)
      product_type.should_not be_admin_deleteable
    end

  end

end
