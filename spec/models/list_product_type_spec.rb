require 'spec_helper'

describe ListProductType do

  let(:list_product_type) { create(:list_product_type) }

  it "should hide list product type" do
    list_product_type.hide!
    list_product_type.reload.hidden.should be_true
  end

  context "visiblilty" do

    before(:all) do
      @list = create(:list)
      @list.list_product_types << create_list(:list_product_type,
                                              3, list_id: @list.id)
      @list.list_product_types << create(:list_product_type,
                                         list_id: @list.id,
                                         hidden: true)
    end


    it "should only return visible product types" do
      @list.list_product_types.visible.count.should == 3
    end

    it "all visible product types should not be hidden" do
      @list.list_product_types.visible.each do |list_product_type|
        list_product_type.hidden.should be_false
      end
    end

    it "should only return hidden product types" do
      @list.list_product_types.hidden.count.should == 1
    end

    it "all hidden product types should be hidden" do
      @list.list_product_types.hidden.each do |list_product_type|
        list_product_type.hidden.should be_true
      end
    end

  end

end
