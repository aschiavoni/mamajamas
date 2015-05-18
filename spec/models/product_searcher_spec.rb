require 'spec_helper'

describe ProductSearcher, :type => :model do

  matcher = [
    :method,
    VCR.request_matchers.uri_without_param(:Timestamp, :Signature)
  ]

  it "searches catalog for items" do
    VCR.use_cassette('product_searcher/goodnight moon',
                     serialize_with: :psych,
                     match_requests_on: matcher) do
      expect(ProductSearcher.search('goodnight moon').size).to be >= 1
    end
  end

  it "does not find matching item in catalog" do
    VCR.use_cassette('product_searcher/sjlksdfjlksdjflkdsjk',
                     serialize_with: :psych,
                     match_requests_on: matcher) do
      expect(ProductSearcher.search('sjlksdfjlksdjflkdsjk')).to be_empty
    end
  end

  it "limits the number of items returned" do
    VCR.use_cassette('product_searcher/baby',
                     serialize_with: :psych,
                     match_requests_on: matcher) do
      expect(ProductSearcher.search('baby', nil, 1).size).to eq(1)
    end
  end

end
