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

  it "returns age ranges for younger ages" do
    age_range = AgeRange.where(position: 2).first
    younger = age_range.younger.pluck(:position).should == [0, 1]
  end

  it "returns age ranges for older ages" do
    age_range = AgeRange.where(position: 2).first
    older = age_range.older.each do |w|
      w.position.should > age_range.position
    end
  end

end
