require 'spec_helper'

class FakeProductSearcher
  def self.search(query, search_index, limit); end
end

describe ProductTypeSearcher do

  matcher = [
    :method,
    VCR.request_matchers.uri_without_param(:Timestamp, :Signature)
  ]

  it "finds suggestions for a product name" do
    VCR.use_cassette('product_type_searcher/shampoo',
                     serialize_with: :psych,
                     match_requests_on: matcher) do
      product_type = create(:product_type, name: 'Shampoo')
      suggestions = ProductTypeSearcher.search(product_type)
      suggestions.size.should be > 1
    end
  end

  it "uses product type search index for searching" do
    product_type = build(:product_type, search_index: 'Baby')
    FakeProductSearcher.should_receive(:search).
      with(anything(), 'Baby', anything()).
      and_return([])

    ProductTypeSearcher.new(FakeProductSearcher).search(product_type)
  end

  it "uses 'All' search index for searching when product type has none" do
    product_type = build(:product_type, search_index: nil)
    FakeProductSearcher.should_receive(:search).
      with(anything(), 'All', anything()).
      and_return([])

    ProductTypeSearcher.new(FakeProductSearcher).search(product_type)
  end

  it "uses search query for searching" do
    product_type = build(:product_type, search_query: 'Baby Towel')
    FakeProductSearcher.should_receive(:search).
      with(product_type.search_query, 'All', anything()).
      and_return([])

    ProductTypeSearcher.new(FakeProductSearcher).search(product_type)
  end

  it "uses product type name for query when no search query specified" do
    product_type = build(:product_type)
    FakeProductSearcher.should_receive(:search).
      with(product_type.name, 'All', anything()).
      and_return([])

    ProductTypeSearcher.new(FakeProductSearcher).search(product_type)
  end

end
