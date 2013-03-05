require 'spec_helper'

describe WhenToBuySuggestion do

  describe "is valid" do

    it "must have a name" do
      when_to_buy = build(:when_to_buy_suggestion, name: nil)
      when_to_buy.should_not be_valid
    end

    it "must have a position" do
      when_to_buy = build(:when_to_buy_suggestion, position: nil)
      when_to_buy.should_not be_valid
    end

  end

  it "returns suggestions for younger ages" do
    when_to_buy = WhenToBuySuggestion.where(position: 2).first
    younger = when_to_buy.younger.pluck(:position).should == [0, 1]
  end

  it "returns suggestions for older ages" do
    when_to_buy = WhenToBuySuggestion.where(position: 2).first
    older = when_to_buy.older.each do |w|
      w.position.should > when_to_buy.position
    end
  end

end
