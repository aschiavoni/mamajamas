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
      product_type = build(:product_type, name: 'Shampoo')
      ProductTypeSuggestions.find(product_type).should have_at_least(1).product
    end
  end

end
