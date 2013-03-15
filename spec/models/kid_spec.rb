require 'spec_helper'

describe Kid do

  context "age range" do

    it "returns the name of the age range" do
      kid = build(:kid)
      kid.age_range_name.should == kid.age_range.name
    end

    it "returns nil if the kid does not have an age range" do
      kid = build(:kid, age_range: nil)
      kid.age_range_name.should be_nil
    end

    it "sets the age range based on the name" do
      kid = build(:kid)
      age_range = create(:age_range)

      kid.age_range_name = age_range.name
      kid.age_range.should == age_range
    end

  end
end
