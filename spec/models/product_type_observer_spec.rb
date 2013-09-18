require 'spec_helper'

describe ProductTypeObserver do

  let(:product_type) { create(:product_type) }

  it "downcases image name when saved" do
    product_type.image_name = "Heyo.png"
    product_type.save!
    product_type.reload

    product_type.image_name.should == "heyo.png"
  end

  it "downcases image name when created" do
    product_type = ProductType.create!(
      name: "some product type",
      plural_name: "some product types",
      image_name: "Heyo.png")

    product_type.reload

    product_type.image_name.should == "heyo.png"
  end

end
