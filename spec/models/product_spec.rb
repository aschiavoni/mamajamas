# encoding: UTF-8

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

    before(:all) { 2.times { create(:product) } }

    before(:each) do
      Timecop.travel(2.days.from_now)
    end

    after(:each) { Timecop.return }

    describe "expired products" do

      it "should not find expired products when using active scope" do
        subject.class.active.size.should == 0
      end

      it "should find expired products when using expired scope" do
        subject.class.expired.all.size.should == Product.count
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
        subject.class.expired.size.should == Product.count - 2
      end

    end

  end

  describe "product types" do

    before(:all) do
      @product_types = create_list(:product_type, 3)
      @product = create(:product)

      @product_types.each do |product_type|
        @product.product_types << product_type
      end
    end

    it "should return all product types" do
      @product.product_types.size.should == @product_types.size
    end

    it "should include all product types" do
      @product_types.each do |product_type|
        @product.product_types.should include(product_type)
      end
    end

  end

  describe "searching" do

    it "searches product names with full text search" do
      product_name = 'new ssddyy product'
      product = create(:product, name: product_name)
      Product.text_search('ssdd').first.should == product
    end

    it "searches product brands with full text search" do
      brand_name = 'tt jjkkll aa'
      product = create(:product, brand: brand_name)
      Product.text_search('jjkk').first.should == product
    end

    it "searches product categories with full text search" do
      categories = 'category1, category2, category3'
      product = create(:product, categories: categories)
      Product.text_search('category2').first.should == product
    end

    it "ignores accented characters in a search" do
      product_name = 'El Niña'
      product = create(:product, name: product_name)
      Product.text_search('nina').first.should == product
    end

    it "returns all products if no query" do
      Product.text_search(nil).count.should == Product.count
    end

  end

end
