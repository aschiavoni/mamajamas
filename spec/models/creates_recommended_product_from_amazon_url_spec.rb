require 'spec_helper'

describe CreatesRecommendedProductFromAmazonUrl do

  matcher = [
    :method,
    VCR.request_matchers.uri_without_param(:Timestamp, :Signature)
  ]

  vcr_opts = { match_requests_on: matcher}

  def cs_name(suffix)
    "creates_recommended_product_from_amazon_url/#{suffix}"
  end

  let(:url) do
    "http://www.amazon.com/Manhattan-Toy-200940-Winkel/dp/B000BNCA4K%3FSubscriptionId%3DAKIAIXAEIBVZBZEU56MQ%26tag%3Dmamajamas-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3DB000BNCA4K"
  end

  let(:asin) { "B000BNCA4K" }

  let(:ecs_config) { ProductFetcherConfiguration.for('amazon') }

  it "finds vendor id in url" do
    VCR.use_cassette(cs_name("vendor_id"), vcr_opts) do
      c = CreatesRecommendedProductFromAmazonUrl.new(url, ecs_config)
      c.vendor_id.should == asin
    end
  end

  it "includes amazon asin vendor id" do
    VCR.use_cassette(cs_name("asin"), vcr_opts) do
      c = CreatesRecommendedProductFromAmazonUrl.new(url, ecs_config)
      c.product.should include(vendor_id: asin)
    end
  end

  it "includes amazon affiliate link" do
    VCR.use_cassette(cs_name("affiliate"), vcr_opts) do
      c = CreatesRecommendedProductFromAmazonUrl.new(url, ecs_config)
      c.product[:link].should include("mamajamas-20")
    end
  end

  it "includes image url" do
    VCR.use_cassette(cs_name("image_url"), vcr_opts) do
      c = CreatesRecommendedProductFromAmazonUrl.new(url, ecs_config)
      c.product[:image_url].should include("http://ecx.images-amazon.com")
    end
  end

  it "retrieves product name from amazon" do
    VCR.use_cassette(cs_name("name"), vcr_opts) do
      c = CreatesRecommendedProductFromAmazonUrl.new(url, ecs_config)
      c.product.should include(name: "Manhattan Toy Winkel")
    end
  end

end
