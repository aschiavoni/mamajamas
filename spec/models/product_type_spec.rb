require 'spec_helper'

describe ProductType do

  let(:bathing_category) { create(:category, name: "bathing") }
  let(:changing_category) { create(:category, name: "changing") }
  let(:categories) { [ bathing_category, changing_category ] }

  describe "by category" do

    before(:all) do
      @b1 = create(:product_type, category_id: bathing_category.id)
      @b2 = create(:product_type, category_id: bathing_category.id)
      @c1 = create(:product_type, category_id: changing_category.id)
      @c2 = create(:product_type, category_id: changing_category.id)
      @all_product_types = [ @b1, @b2, @c1, @c2 ]
    end

    describe "filtered by category" do

      before(:all) do
        @results = subject.class.by_category(bathing_category)
      end

      it "should only include product types in the bathing category" do
        @results.should include(@b1)
      end

      it "should include all bathing product types" do
        @results.size.should == 2 # @b1 and @b2
      end

      it "should not include product types in the changing category" do
        @results.should_not include(@c1)
      end

    end

    describe "filtered by nil category" do

      before(:all) do
        @results = subject.class.by_category(nil)
      end

      it "should include all product types" do
        @results.size.should == ProductType.count
      end

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
