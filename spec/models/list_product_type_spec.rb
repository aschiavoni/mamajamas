require 'spec_helper'

describe ListProductType do

  let(:list_product_type) { create(:list_product_type) }

  it "should hide list product type" do
    list_product_type.hide!
    list_product_type.reload.hidden.should be_true
  end

end
