require 'spec_helper'

describe AgeRange do

  describe "is valid" do

    it "must have a name" do
      age_range = build(:age_range, name: nil)
      age_range.should_not be_valid
    end

    it "must have a position" do
      age_range = build(:age_range, position: nil)
      age_range.should_not be_valid
    end

  end

  it "finds age range by normalized name" do
    AgeRange.find_by_normalized_name!("Pre-Birth").should == AgeRangeComparer.new.pre_birth
  end

  it "raise RecordNotFound if age range can't be found via normalized name" do
    lambda {
      AgeRange.find_by_normalized_name!("whatever")
    }.should raise_error(ActiveRecord::RecordNotFound)
  end

end
