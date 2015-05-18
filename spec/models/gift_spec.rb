require 'spec_helper'

RSpec.describe Gift, :type => :model do

  let(:list_item) { create(:list_item) }

  it "updates list item gifted quantity when gift is created" do
    create(:gift, list_item_id: list_item.id)
    list_item.reload.gifted_quantity.should == 1
  end

  it "updates list item gifted quantity when gift is updated" do
    gift = create(:gift, list_item_id: list_item.id)
    gift.update_attributes(quantity: 3)
    list_item.reload.gifted_quantity.should == 3
  end

  it "updates list item gifted quantity when gift is destroyed" do
    gift = create(:gift, list_item_id: list_item.id)
    gift.destroy
    list_item.reload.gifted_quantity.should == 0
  end

end
