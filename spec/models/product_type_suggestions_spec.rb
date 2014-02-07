require 'spec_helper'

describe ProductTypeSuggestions do
  let(:product_type) { build(:product_type) }

  it "returns a hash with product type id" do
    ProductLookup.should_receive(:lookup).exactly(2).times { [] }
    ProductTypeSearcher.should_receive(:search).with(product_type) {
      [ Product.new, Product.new ]
    }

    ProductTypeSuggestions.find(product_type)[:id].should == product_type.id
  end

  it "returns a hash with suggestions" do
    ProductLookup.should_receive(:lookup).exactly(2).times { [] }
    ProductTypeSearcher.should_receive(:search).with(product_type) {
      [ Product.new(vendor_id: "one"), Product.new(vendor_id: "two") ]
    }

    ProductTypeSuggestions.find(product_type)[:suggestions].size.should == 2
  end

  it "returns only products with a unique vendor id" do
    ProductLookup.should_receive(:lookup).exactly(2).times { [] }
    ProductTypeSearcher.should_receive(:search).with(product_type) {
      [ Product.new(vendor_id: "one"), Product.new(vendor_id: "one") ]
    }

    ProductTypeSuggestions.find(product_type)[:suggestions].size.should == 1
  end

  it "looks up recommended products" do
    recids = [ "1", "2" ]
    RecommendedProduct.should_receive(:suggestable_vendor_ids) { recids }
    ProductLookup.should_receive(:lookup).with(recids) { [] }
    ProductLookup.should_receive(:lookup) { [] }
    ProductTypeSearcher.should_receive(:search).with(product_type) { [] }
    ProductTypeSuggestions.find(product_type)
  end

  it "looks up rated products" do
    ids = [ "1", "2" ]
    ProductRating.should_receive(:suggestable_vendor_ids) { ids }
    ProductLookup.should_receive(:lookup) { [] }
    ProductLookup.should_receive(:lookup).with(ids) { [] }
    ProductTypeSearcher.should_receive(:search).with(product_type) { [] }
    ProductTypeSuggestions.find(product_type)
  end

  it "searches for product type" do
    ProductLookup.should_receive(:lookup).exactly(2).times { [] }
    ProductTypeSearcher.should_receive(:search).with(product_type) { [] }
    ProductTypeSuggestions.find(product_type)
  end
end
