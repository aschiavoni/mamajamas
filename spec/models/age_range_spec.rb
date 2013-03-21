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

  it "finds age range by normalized name" do
    AgeRange.find_by_normalized_name!("Pre-Birth").should == AgeRange.pre_birth
  end

  it "raise RecordNotFound if age range can't be found via normalized name" do
    lambda {
      AgeRange.find_by_normalized_name!("whatever")
    }.should raise_error(ActiveRecord::RecordNotFound)
  end

  context "Pre-defined ages" do

    subject { AgeRange }

    it "returns a pre-birth age" do
      subject.pre_birth.should_not be_nil
    end

    it "returns a age for 0-3 mos" do
      subject.zero_to_three_months.should_not be_nil
    end

    it "returns a age for 13-18 mos" do
      subject.thirteen_to_eighteen_months.should_not be_nil
    end

    it "returns a age for 2y" do
      subject.two_years.should_not be_nil
    end

    it "identifies a newborn" do
      age = subject.zero_to_three_months
      age.should be_newborn
    end

    it "identifies a kid who is not a newborn" do
      subject.pre_birth.should_not be_newborn
    end

    it "identifies an infant" do
      subject.thirteen_to_eighteen_months.should be_infant
    end

    it "identifies a kid who is not an infant" do
      subject.two_years.should_not be_infant
    end

  end

end
