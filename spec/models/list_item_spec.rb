require 'spec_helper'

describe ListItem do

  let(:bathing_category) { create(:category, name: "bathing") }
  let(:changing_category) { create(:category, name: "changing") }
  let(:categories) { [ bathing_category, changing_category ] }

  describe "is valid" do

    it "must have a name" do
      list_item = build(:list_item, name: nil)
      list_item.should_not be_valid
    end

    it "must have a link" do
      list_item = build(:list_item, link: nil)
      list_item.should_not be_valid
    end

  end

  describe "by category" do

    before(:all) do
      @b1 = create(:list_item, category_id: bathing_category.id)
      @b2 = create(:list_item, category_id: bathing_category.id)
      @c1 = create(:list_item, category_id: changing_category.id)
      @c2 = create(:list_item, category_id: changing_category.id)
      @all_list_items = [ @b1, @b2, @c1, @c2 ]
    end

    describe "filtered by category" do

      before(:all) do
        @results = subject.class.by_category(bathing_category)
      end

      it "should only include list items in the bathing category" do
        @results.should include(@b1)
      end

      it "should include all bathing list items" do
        @results.size.should == 2 # @b1 and @b2
      end

      it "should not include list items in the changing category" do
        @results.should_not include(@c1)
      end

    end

    describe "filtered by nil category" do

      before(:all) do
        @results = subject.class.by_category(nil)
      end

      it "should include all list items" do
        @results.size.should == @all_list_items.size
      end

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
