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

  describe "age range" do

    let(:age_range) { build(:age_range) }

    it "should return age range name" do
      li = build(:list_item, age_range: age_range)
      li.age.should == age_range.name
    end

    it "should set age range from name" do
      li = build(:list_item)
      AgeRange.should_receive(:find_by_name).with(age_range.name).and_return(age_range)
      li.age = age_range.name
      li.age.should == age_range.name
    end

    it "should not change age range with an unknown name" do
      li = build(:list_item)
      lambda do
        li.age = "unknown"
      end.should_not change(li, :age)
    end

  end

end
