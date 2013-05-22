require 'spec_helper'

describe ProductSearcher do

  matcher = [
    :method,
    VCR.request_matchers.uri_without_param(:Timestamp, :Signature)
  ]

  it "searches catalog for items" do
    VCR.use_cassette('product_searcher/goodnight moon',
                     serialize_with: :syck,
                     match_requests_on: matcher) do
      ProductSearcher.search('goodnight moon').should have_at_least(1).product
    end
  end

  it "does not find matching item in catalog" do
    VCR.use_cassette('product_searcher/sjlksdfjlksdjflkdsjk',
                     serialize_with: :syck,
                     match_requests_on: matcher) do
      ProductSearcher.search('sjlksdfjlksdjflkdsjk').should be_empty
    end
  end

  it "limits the number of items returned" do
    VCR.use_cassette('product_searcher/baby',
                     serialize_with: :syck,
                     match_requests_on: matcher) do
      ProductSearcher.search('baby', 1).should have(1).products
    end
  end

  # this requires that all MediumImage elements are removed from the response
  # i.e. if you re-generate the cassette, you will have to manually edit it
  it "excludes products with no medium image url" do
    VCR.use_cassette('product_searcher/hungry caterpillar',
                     serialize_with: :syck,
                     match_requests_on: matcher) do
      ProductSearcher.search('hungry caterpillar').should be_empty
    end
  end

end
