require 'spec_helper'

describe ProductTypeDecorator do

  let(:product_type) { build(:product_type).extend ProductTypeDecorator }

  subject { product_type }

  it { is_expected.to be_a ProductType }

  describe "cagtegory name" do

    it "knows category name" do
      expect(product_type.category_name).to eq(product_type.category.name)
    end

  end

end
