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
end
