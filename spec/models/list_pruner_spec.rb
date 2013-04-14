require 'spec_helper'

describe ListPruner do

  let(:user) { create(:user) }
  let(:list) { user.build_list! }

  before(:each) do
    2.times { create(:product_type, priority: 3) }
  end

  it "removes all low priority placeholders from the list" do
    ListPruner.new(list).prune!
    list.list_items.where(placeholder: true).map(&:priority).should_not include(3)
  end

  it "does not remove non-placeholder items with low priority" do
    2.times do
      list.add_list_item(ListItem.create!({
        name: 'a new item',
        link: 'http://example.com/items/a-new-item',
        priority: 3
      }))
    end
    ListPruner.new(list).prune!
    list.list_items.where(placeholder: false).count.should == 2
  end

end
