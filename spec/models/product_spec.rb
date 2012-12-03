require 'spec_helper'

describe Product do

  describe "is valid" do

    it "must have a name" do
      product = build(:product, name: nil)
      product.should_not be_valid
    end

    it "must have a url" do
      product = build(:product, url: nil)
      product.should_not be_valid
    end

    it "must have a product type id" do
      product = build(:product, product_type: nil)
      product.should_not be_valid
    end

    it "must have a vendor id" do
      product = build(:product, vendor_id: nil)
      product.should_not be_valid
    end

    it "must have a unique vendor id" do
      product = create(:product)

      new_product = build(:product, vendor_id: product.vendor_id)
      new_product.should_not be_valid
    end

  end

  describe "expiration" do

    before(:each) do
      2.times { create(:product) }
      Timecop.travel(2.days.from_now)
    end

    after(:each) { Timecop.return }

    describe "expired products" do

      it "should not find expired products when using active scope" do
        subject.class.active.size.should == 0
      end

      it "should find expired products when using expired scope" do
        subject.class.expired.all.size.should == 2
      end

    end

    describe "active products" do

      before(:each) do
        # at this point, we are in the future and are creating two
        # more "active products"
        2.times { create(:product) }
      end

      it "should only find active products when using active scope" do
        subject.class.active.size.should == 2
      end

      it "should only find expired products when using expired scope" do
        subject.class.expired.size.should == 2
      end

    end

  end

end
