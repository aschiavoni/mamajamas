require 'spec_helper'

describe ProductTypeSuggestions, :type => :model do
  let(:product_type) { build(:product_type) }

  it "returns a hash with product type id" do
    expect(ProductLookup).to receive(:lookup).exactly(2).times { [] }
    expect(ProductTypeSearcher).to receive(:search).with(product_type) {
      [ Product.new, Product.new ]
    }

    expect(ProductTypeSuggestions.find(product_type)[:id]).to eq(product_type.id)
  end

  it "returns a hash with suggestions" do
    expect(ProductLookup).to receive(:lookup).exactly(2).times { [] }
    expect(ProductTypeSearcher).to receive(:search).with(product_type) {
      [ Product.new(vendor_id: "one"), Product.new(vendor_id: "two") ]
    }

    expect(ProductTypeSuggestions.find(product_type)[:suggestions].size).to eq(2)
  end

  it "returns only products with a unique vendor id" do
    expect(ProductLookup).to receive(:lookup).exactly(2).times { [] }
    expect(ProductTypeSearcher).to receive(:search).with(product_type) {
      [ Product.new(vendor_id: "one"), Product.new(vendor_id: "one") ]
    }

    expect(ProductTypeSuggestions.find(product_type)[:suggestions].size).to eq(1)
  end

  it "looks up recommended products" do
    recids = [ "1", "2" ]
    expect(RecommendedProduct).to receive(:suggestable_vendor_ids) { recids }
    expect(ProductLookup).to receive(:lookup).with(recids) { [] }
    expect(ProductLookup).to receive(:lookup) { [] }
    expect(ProductTypeSearcher).to receive(:search).with(product_type) { [] }
    ProductTypeSuggestions.find(product_type)
  end

  it "looks up rated products" do
    ids = [ "1", "2" ]
    expect(ProductRating).to receive(:suggestable_vendor_ids) { ids }
    expect(ProductLookup).to receive(:lookup) { [] }
    expect(ProductLookup).to receive(:lookup).with(ids) { [] }
    expect(ProductTypeSearcher).to receive(:search).with(product_type) { [] }
    ProductTypeSuggestions.find(product_type)
  end

  it "searches for product type" do
    expect(ProductLookup).to receive(:lookup).exactly(2).times { [] }
    expect(ProductTypeSearcher).to receive(:search).with(product_type) { [] }
    ProductTypeSuggestions.find(product_type)
  end
end
