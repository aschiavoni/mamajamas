require 'spec_helper'

RSpec.describe Address, :type => :model do
  describe "is valid" do

    it "must have a street" do
      address = build(:address, street: nil)
      expect(address).not_to be_valid
    end

    it "must have a city" do
      address = build(:address, city: nil)
      expect(address).not_to be_valid
    end

    it "must have a region" do
      address = build(:address, region: nil)
      expect(address).not_to be_valid
    end

    it "must have a postal code" do
      address = build(:address, postal_code: nil)
      expect(address).not_to be_valid
    end

    it "must have a country code" do
      address = build(:address, country_code: nil)
      expect(address).not_to be_valid
    end

    it "must have a country code that does not exceed 2 characters" do
      address = build(:address, country_code: "USD")
      expect(address).not_to be_valid
    end

  end
end
