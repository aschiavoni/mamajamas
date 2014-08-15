require 'spec_helper'

describe AgeRange, :type => :model do

  describe "is valid" do

    it "must have a name" do
      age_range = build(:age_range, name: nil)
      expect(age_range).not_to be_valid
    end

    it "must have a position" do
      age_range = build(:age_range, position: nil)
      expect(age_range).not_to be_valid
    end

  end

  it "finds age range by normalized name" do
    expect(AgeRange.find_by_normalized_name!("Pre-Birth")).to eq(AgeRangeComparer.new.pre_birth)
  end

  it "raise RecordNotFound if age range can't be found via normalized name" do
    expect {
      AgeRange.find_by_normalized_name!("whatever")
    }.to raise_error(ActiveRecord::RecordNotFound)
  end

end
