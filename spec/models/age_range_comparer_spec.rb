require 'spec_helper'

describe AgeRangeComparer, :type => :model do

  let(:comparer) { AgeRangeComparer.new }

  it "returns age ranges for younger ages" do
    age_range = AgeRange.where(position: 2).first
    expect(comparer.younger(age_range).pluck(:position)).to eq([0, 1])
  end

  it "returns age ranges for older ages" do
    age_range = AgeRange.where(position: 2).first
    older = comparer.older(age_range).each do |w|
      expect(w.position).to be > age_range.position
    end
  end

  context "Pre-defined ages" do

    subject { AgeRangeComparer.new }

    it "returns a pre-birth age" do
      expect(subject.pre_birth).not_to be_nil
    end

    it "returns a age for 0-3 mos" do
      expect(subject.zero_to_three_months).not_to be_nil
    end

    it "returns a age for 13-18 mos" do
      expect(subject.thirteen_to_eighteen_months).not_to be_nil
    end

    it "returns a age for 2y" do
      expect(subject.two_years).not_to be_nil
    end

    it "identifies a newborn" do
      age = subject.zero_to_three_months
      expect(subject.newborn?(age)).to be_truthy
    end

    it "identifies a kid who is not a newborn" do
      expect(subject.newborn?(subject.pre_birth)).not_to be_truthy
    end

    it "identifies an infant" do
      age = subject.thirteen_to_eighteen_months
      expect(subject.infant?(age)).to be_truthy
    end

    it "identifies a kid who is not an infant" do
      expect(subject.infant?(subject.two_years)).not_to be_truthy
    end

  end
end
