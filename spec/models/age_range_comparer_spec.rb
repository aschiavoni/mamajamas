require 'spec_helper'

describe AgeRangeComparer do

  let(:comparer) { AgeRangeComparer.new }

  it "returns age ranges for younger ages" do
    age_range = AgeRange.where(position: 2).first
    younger = comparer.younger(age_range).pluck(:position).should == [0, 1]
  end

  it "returns age ranges for older ages" do
    age_range = AgeRange.where(position: 2).first
    older = comparer.older(age_range).each do |w|
      w.position.should > age_range.position
    end
  end

  context "Pre-defined ages" do

    subject { AgeRangeComparer.new }

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
      subject.newborn?(age).should be_true
    end

    it "identifies a kid who is not a newborn" do
      subject.newborn?(subject.pre_birth).should_not be_true
    end

    it "identifies an infant" do
      age = subject.thirteen_to_eighteen_months
      subject.infant?(age).should be_true
    end

    it "identifies a kid who is not an infant" do
      subject.infant?(subject.two_years).should_not be_true
    end

  end
end
