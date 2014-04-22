require 'spec_helper'

describe ListCopier do
  let(:source) {
    create(:list)
  }

  let(:target) {
    create(:list)
  }

  def add_items(list, count)
    count.times do
      list.add_list_item build(:list_item, list: nil, rating: 4, owned: true)
    end
    list.save!
  end

  it "copies all list items" do
    add_items source, 3
    copier = ListCopier.new source, target

    lambda do
      copier.copy
    end.should change(target.list_items, :count).by(3)
  end

  it "removes rating from copied items" do
    add_items source, 3
    copier = ListCopier.new source, target

    copier.copy
    target.reload.list_items.pluck(:rating).uniq.should == [ 0 ]
  end

  it "sets all copied items to not owned" do
    add_items source, 3
    copier = ListCopier.new source, target

    copier.copy
    target.reload.list_items.pluck(:owned).uniq.should == [ false ]
  end

  it "does not copy low priority items" do
    add_items source, 3
    source.add_list_item build(:list_item, list: nil, priority: 3,
                               rating: 4, owned: true)
    copier = ListCopier.new source, target
    copier.copy
    target.reload.list_items.user_items.count.should == 3
  end

  it "does not copy items that already exist on list" do
    target.add_list_item(build(:list_item, list: nil,
                               vendor: "amazon",
                               vendor_id: "12345"), false)
    source.add_list_item(build(:list_item, list: nil,
                               vendor: "amazon",
                               vendor_id: "12345"), false)

    copier = ListCopier.new source, target
    copier.copy
    target.reload.list_items.user_items.count.should == 1
  end

  context "replacing placeholders" do

    before(:each) do
      @ph = target.add_list_item build(:list_item, list: nil), true
      target.save!

      @li = source.add_list_item build(:list_item, list: nil,
                                       product_type: @ph.product_type,
                                       product_type_name: @ph.product_type.name)
      source.save!
      @copier = ListCopier.new source, target
    end

    it "does not change count of list items" do
      lambda {
        @copier.copy
      }.should_not change(target.reload.list_items, :count)
    end

    it "removes placeholder from target" do
      @copier.copy
      target.reload.list_items.placeholders.count.should == 0
    end

    it "adds source list item to target" do
      @copier.copy
      target.reload.list_items.user_items.first.name.should == @li.name
    end

  end

end
