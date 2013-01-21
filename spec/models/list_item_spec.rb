require 'spec_helper'

describe ListItem do

  describe "is valid" do

    it "must have a name" do
      list_item = build(:list_item, name: nil)
      list_item.should_not be_valid
    end

    it "must have a link" do
      list_item = build(:list_item, link: nil)
      list_item.should_not be_valid
    end

    it "does not need a name if it is a placeholder" do
      list_item = build(:list_item, placeholder: true, name: nil)
      list_item.should be_valid
    end

    it "does not need a link if it is a placeholder" do
      list_item = build(:list_item, placeholder: true, link: nil)
      list_item.should be_valid
    end

  end

  describe "by category" do

    it "should query by category if specified" do
      category = stub(:category, id: 1)
      subject.class.should_receive(:where).with(category_id: category.id)
      subject.class.by_category(category)
    end

    it "should not filter results if category is blank" do
      subject.class.should_receive(:scoped)
      subject.class.by_category(nil)
    end

  end

  describe "when to buy" do

    let(:when_to_buy_suggestion) { build(:when_to_buy_suggestion) }

    it "should return when to buy suggestion name" do
      li = build(:list_item, when_to_buy_suggestion: when_to_buy_suggestion)
      li.when_to_buy.should == when_to_buy_suggestion.name
    end

    it "should set when to buy suggestion from name" do
      li = build(:list_item)
      WhenToBuySuggestion.should_receive(:find_by_name).with(when_to_buy_suggestion.name).and_return(when_to_buy_suggestion)
      li.when_to_buy = when_to_buy_suggestion.name
      li.when_to_buy.should == when_to_buy_suggestion.name
    end

    it "should not change when to buy suggestion with an unknown name" do
      li = build(:list_item)
      lambda do
        li.when_to_buy = "unknown"
      end.should_not change(li, :when_to_buy)
    end

  end

end
