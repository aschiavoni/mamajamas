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

    it "does not accept unknown atrributes" do
      lambda do
        product = Product.new(nada: "value")
      end.should raise_error(NoMethodError)
    end

  end

end
