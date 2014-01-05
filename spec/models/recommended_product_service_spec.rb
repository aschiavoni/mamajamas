require 'spec_helper'

describe RecommendedProductService do

  matcher = [
    :method,
    VCR.request_matchers.uri_without_param(:Timestamp, :Signature)
  ]

  vcr_opts = { match_requests_on: matcher}

  def cs_name(suffix)
    "recommended_product_service/#{suffix}"
  end

  let(:attrs) do
    {
      "eco"=> {
        "product_type_id"=>"6",
        "tag"=>"eco",
        "link"=>"http://www.amazon.com/My-Brest-Friend-Pillow-Sunburst/dp/B000HZEQSU%3FSubscriptionId%3DAKIAIXAEIBVZBZEU56MQ%26tag%3Dmamajamas-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3DB000HZEQSU",
        "name"=>""},
      "cost_conscious"=>{
        "product_type_id"=>"6",
        "tag"=>"cost_conscious",
        "link"=>"http://www.amazon.com/Manhattan-Toy-200940-Winkel/dp/B000BNCA4K%3FSubscriptionId%3DAKIAIXAEIBVZBZEU56MQ%26tag%3Dmamajamas-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3DB000BNCA4K",
        "name"=>""},
      "extra"=> {
        "product_type_id"=>"6",
        "tag"=>"extra",
        "link"=>"",
        "name"=>""}
    }
  end

  it "creates a recommended product from an attribute hash" do
    VCR.use_cassette(cs_name("create"), vcr_opts) do
      lambda do
        RecommendedProductService.create_or_update!(attrs)
      end.should change(RecommendedProduct, :count).by(2)
    end
  end

  it "updates a recommended product from an attribute hash" do
    VCR.use_cassette(cs_name("update"), vcr_opts) do
      rp = create(:recommended_product, tag: "eco")
      a = attrs
      a["eco"]["product_type_id"] = rp.product_type_id
      RecommendedProductService.create_or_update!(attrs)
      rp.reload

      rp.link.should == "http://www.amazon.com/My-Brest-Friend-Pillow-Sunburst/dp/B000HZEQSU%3FSubscriptionId%3DAKIAIXAEIBVZBZEU56MQ%26tag%3Dmamajamas-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3DB000HZEQSU"
      rp.name.should == "My Brest Friend Pillow, Sunburst"
    end
  end

  it "ignores a product with a blank link" do
    params = {
      "eco" => { "link" => "", "tag" => "eco" }
    }
    lambda do
      RecommendedProduct.any_instance.should_not_receive(:update_attributes!)
      RecommendedProduct.any_instance.should_not_receive(:create!)
      CreatesRecommendedProductFromAmazonUrl.should_not_receive(:new)
      RecommendedProductService.create_or_update!(params)
    end.should_not change(RecommendedProduct, :count)
  end

  it "deletes an existing product if a blank link is specified" do
    rp = create(:recommended_product, tag: "eco")
    params = {
      "eco" => {
        "link" => "",
        "product_type_id" => rp.product_type_id,
        "tag" => "eco" }
    }
    lambda do
      RecommendedProduct.any_instance.should_not_receive(:update_attributes!)
      RecommendedProduct.any_instance.should_not_receive(:create!)
      CreatesRecommendedProductFromAmazonUrl.should_not_receive(:new)
      RecommendedProductService.create_or_update!(params)
    end.should change(RecommendedProduct, :count).by(-1)
  end

  it "overrides amazon name" do
    params = {
      "eco"=> {
        "product_type_id"=>"6",
        "tag"=>"eco",
        "link"=>"http://www.amazon.com/My-Brest-Friend-Pillow-Sunburst/dp/B000HZEQSU%3FSubscriptionId%3DAKIAIXAEIBVZBZEU56MQ%26tag%3Dmamajamas-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3DB000HZEQSU",
        "name"=>"My Product Name"
      }
    }

    VCR.use_cassette(cs_name("override_name"), vcr_opts) do
      RecommendedProductService.create_or_update!(params)
      RecommendedProduct.first.name.should == "My Product Name"
    end
  end

end
