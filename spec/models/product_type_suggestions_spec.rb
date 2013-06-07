require 'spec_helper'

describe ProductTypeSuggestions do

  matcher = [
    :method,
    VCR.request_matchers.uri_without_param(:Timestamp, :Signature)
  ]

  it "finds suggestions for a product name" do
    VCR.use_cassette('product_searcher/shampoo',
                     serialize_with: :syck,
                     match_requests_on: matcher) do
      product_type = create(:product_type, name: 'Shampoo')
      suggestions = ProductTypeSuggestions.find(product_type)
      suggestions[:id].should == product_type.id
      suggestions[:suggestions].size.should be > 1
    end
  end

end
