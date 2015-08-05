require 'spec_helper'

describe Kid, :type => :model do

  context "age range" do

    it "returns the name of the age range" do
      kid = build(:kid)
      expect(kid.age_range_name).to eq(kid.age_range.name)
    end

    it "returns nil if the kid does not have an age range" do
      kid = build(:kid, age_range: nil)
      expect(kid.age_range_name).to be_nil
    end

    it "sets the age range based on the name" do
      kid = build(:kid)
      age_range = create(:age_range)

      kid.age_range_name = age_range.name
      expect(kid.age_range).to eq(age_range)
    end

  end
end
