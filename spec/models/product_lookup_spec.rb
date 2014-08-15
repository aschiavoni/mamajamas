require 'spec_helper'

describe ProductLookup do

  matcher = [
    :method,
    VCR.request_matchers.uri_without_param(:Timestamp, :Signature)
  ]

  it "looks in catalog for items" do
    VCR.use_cassette('product_lookup/goodnight moon',
                     serialize_with: :psych,
                     match_requests_on: matcher) do
      asins = [ "0062235893", "B000056OV0" ]
      # ProductLookup.lookup(asins).should have(2).products
      expect(ProductLookup.lookup(asins).size).to eq(2)
    end
  end

  it "does not find matching item in catalog" do
    VCR.use_cassette('product_lookup/sjlksdfjlksdjflkdsjk',
                     serialize_with: :psych,
                     match_requests_on: matcher) do
      asins = [ "sjlksdfjlksdjflkdsjk" ]
      ProductLookup.lookup(asins).should be_empty
    end
  end

end
