require 'spec_helper'

describe Quiz::Feeding, :type => :model do

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
    expect(subject.choices).not_to be_empty
  end

  it "does not accept an invalid answer" do
    expect {
      subject.process_answers!("heyo")
    }.to raise_error(ArgumentError)
  end

  it "sets priority if a single option is included" do
    expect(subject.as_null_object).
      to receive(:set_priority).
      with("Bottle Brush", 1)

    subject.process_answers!("Pump", "Bottle Feed")
  end

  it "sets priority if a multiple options are included" do
    expect(subject.as_null_object).
      to receive(:set_priority).
      with("Bottle Warmer", 2)

    subject.process_answers!("Pump", "Breast Feed")
  end

  it "sets priority if only a single answer is submitted" do
    expect(subject.as_null_object).
      to receive(:set_priority).
      with("Nursing Pads", 3)

    subject.process_answers!("Bottle Feed")
  end

  it "doesn't set priority if the single answer does not match" do
    expect(subject.as_null_object).
      not_to receive(:set_priority).
      with("Nursing Pads", 3)

    subject.process_answers!("Bottle Feed", "Pump")
  end

  it "sets priority if an answer is excluded" do
    expect(subject.as_null_object).
      to receive(:set_priority).
      with("Milk Storage", 3)

    subject.process_answers!("Breast Feed", "Bottle Feed")
  end

  it "does not set priority if an answer is not excluded" do
    expect(subject.as_null_object).
      not_to receive(:set_priority).
      with("Milk Storage", 3)

    subject.process_answers!("Pump", "Breast Feed", "Bottle Feed")
  end
end
