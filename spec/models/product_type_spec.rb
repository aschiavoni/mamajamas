require 'spec_helper'

describe ProductType do

  describe "global" do

    it "should only include global product types" do
      user_product_type = create(:product_type, user: create(:user))
      ProductType.global.should_not include(user_product_type)
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

    let(:when_to_buy_suggestion) { create(:when_to_buy_suggestion) }

    it "should return when to buy suggestion name" do
      pt = build(:product_type, when_to_buy_suggestion: when_to_buy_suggestion)
      pt.when_to_buy.should == when_to_buy_suggestion.name
    end

    it "should set when to buy suggestion from name" do
      pt = build(:product_type)
      WhenToBuySuggestion.should_receive(:find_by_name).with(when_to_buy_suggestion.name).and_return(when_to_buy_suggestion)
      pt.when_to_buy = when_to_buy_suggestion.name
      pt.when_to_buy.should == when_to_buy_suggestion.name
    end

    it "should not change when to buy suggestion with an unknown name" do
      pt = build(:product_type)
      lambda do
        pt.when_to_buy = "unknown"
      end.should_not change(pt, :when_to_buy)
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

  describe "has query" do

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
  end

end
