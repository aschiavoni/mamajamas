require 'spec_helper'

describe Quiz::Feeding do

  let(:user) { create(:user) }

  let(:kid) { create(:kid) }

  let(:list) do
    ListBuilder.new(user, kid).build!
  end

  subject { Quiz::Feeding.new(list) }

  it "initializes with a list" do
    Quiz::Feeding.new(list)
  end

  it "has a list of choices" do
    subject.choices.should_not be_empty
  end

  it "does not accept an invalid answer" do
    lambda {
      subject.answer("heyo")
    }.should raise_error(ArgumentError)
  end

  it "sets priority if a single option is included" do
    subject.as_null_object.
      should_receive(:set_priority).
      with("Bottle Brush", 1)

    subject.answer("Pump", "Bottle Feed")
  end

  it "sets priority if a multiple options are included" do
    subject.as_null_object.
      should_receive(:set_priority).
      with("Bottle Warmer", 1)

    subject.answer("Pump", "Breast Feed")
  end

  it "sets priority if only a single answer is submitted" do
    subject.as_null_object.
      should_receive(:set_priority).
      with("Nursing Pads", 3)

    subject.answer("Bottle Feed")
  end

  it "doesn't set priority if the single answer does not match" do
    subject.as_null_object.
      should_not_receive(:set_priority).
      with("Nursing Pads", 3)

    subject.answer("Bottle Feed", "Pump")
  end

  it "sets priority if an answer is excluded" do
    subject.as_null_object.
      should_receive(:set_priority).
      with("Milk Storage", 3)

    subject.answer("Breast Feed", "Bottle Feed")
  end

  it "does not set priority if an answer is not excluded" do
    subject.as_null_object.
      should_not_receive(:set_priority).
      with("Milk Storage", 3)

    subject.answer("Pump", "Breast Feed", "Bottle Feed")
  end
end
