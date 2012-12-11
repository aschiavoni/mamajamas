require 'spec_helper'

describe ProductTypeQuery do

  describe "validations" do

    it "is valid" do
      build(:product_type_query).should be_valid
    end

    it "must have a product type id" do
      build(:product_type_query, product_type_id: nil).should_not be_valid
    end

    it "must have a query" do
      build(:product_type_query, query: nil).should_not be_valid
    end

  end
end
