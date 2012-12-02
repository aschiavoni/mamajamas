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

end
