require 'spec_helper'

describe ProductTypeDecorator do

  let(:product_type) { build(:product_type).extend ProductTypeDecorator }

  subject { product_type }

  it { should be_a ProductType }

  describe "cagtegory name" do

    it "knows category name" do
      product_type.category_name.should == product_type.category.name
    end

  end

end
