require 'spec_helper'

describe ListBuilder do

  let(:user) { build(:user) }

  let(:builder) { ListBuilder.new(user) }

  it "should build list" do
    builder.build!.should be_an_instance_of(List)
  end

  it "should assign user to list" do
    List.any_instance.should_receive(:user=).with(user)
    builder.build!
  end

  it "should save list" do
    List.any_instance.should_receive(:save!)
    builder.build!
  end

  it "should add list item placeholders" do
    product_types = build_list(:product_type, 3)
    List.any_instance.
      should_receive(:add_list_item_placeholder).
      exactly(product_types.size).times
    list = builder.build!(product_types)
  end

end
