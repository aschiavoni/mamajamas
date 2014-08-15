# encoding: UTF-8

require 'spec_helper'

describe Product, :type => :model do

  describe "is valid" do

    it "must have a name" do
      product = build(:product, name: nil)
      expect(product).not_to be_valid
    end

    it "must have a url" do
      product = build(:product, url: nil)
      expect(product).not_to be_valid
    end

    it "must have a vendor id" do
      product = build(:product, vendor_id: nil)
      expect(product).not_to be_valid
    end

    it "does not accept unknown atrributes" do
      expect do
        product = Product.new(nada: "value")
      end.to raise_error(NoMethodError)
    end

  end

end
