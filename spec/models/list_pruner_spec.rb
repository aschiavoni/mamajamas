require 'spec_helper'

describe ListPruner do

  let(:user) { create(:user) }
  let(:list) { user.build_list! }
  let(:category) { create(:category) }
  let(:age_range) { create(:age_range) }

  before(:each) do
    2.times { create(:product_type, priority: 3) }
  end

  it "does not remove non-placeholder items with low priority" do
    2.times do
      list.add_list_item(ListItem.create!({
        name: 'a new item',
        link: 'http://example.com/items/a-new-item',
        product_type_name: "Bath Tub",
        priority: 3,
        category_id: category.id,
        age_range_id: age_range.id
      }))
    end
    ListPruner.prune!(list)
    list.list_items.user_items.count.should == 2
  end

end
