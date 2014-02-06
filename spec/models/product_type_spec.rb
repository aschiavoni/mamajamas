require 'spec_helper'

describe ProductType do

  describe "global" do

    it "should include global product types" do
      global_product_type = create(:product_type)
      ProductType.global.should include(global_product_type)
    end

    it "should only include global product types" do
      user_product_type = create(:product_type, user: create(:user))
      ProductType.global.should_not include(user_product_type)
    end

  end

  describe "global active" do

    it "should include global product types" do
      global_product_type = create(:product_type)
      ProductType.global_active.should include(global_product_type)
    end

    it "should not include inactive product types" do
      inactive_product_type = create(:product_type, active: false)
      ProductType.global_active.should_not include(inactive_product_type)
    end
  end

  describe "user" do

    it "should include user product types" do
      user_product_type = create(:product_type, user: create(:user))
      ProductType.user.should include(user_product_type)
    end

    it "should only include user product types" do
      global_product_type = create(:product_type)
      ProductType.user.should_not include(global_product_type)
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

  describe "image name" do

    let(:product_type) { create(:product_type) }

    it "should return image name" do
      pt = build(:product_type, image_name: "test.png")
      pt.image_name.should == "test.png"
    end

    it "should return unknown image name when image name is blank" do
      pt = build(:product_type, image_name: nil)
      pt.image_name.should == "unknown.png"
    end

    it "downcases image name when saved" do
      product_type.image_name = "Heyo.png"
      product_type.save!
      product_type.reload

      product_type.image_name.should == "heyo.png"
    end

    it "downcases image name when created" do
      product_type = ProductType.create!(
                                         name: "some product type",
                                         plural_name: "some product types",
                                         image_name: "Heyo.png")

      product_type.reload

      product_type.image_name.should == "heyo.png"
    end

  end

  describe "when to buy" do

    let(:age_range) { create(:age_range) }

    it "should return age range name" do
      pt = build(:product_type, age_range: age_range)
      pt.age.should == age_range.name
    end

    it "should set age range from name" do
      pt = build(:product_type)
      AgeRange.should_receive(:find_by_name).with(age_range.name).and_return(age_range)
      pt.age = age_range.name
      pt.age.should == age_range.name
    end

    it "should not change age range with an unknown name" do
      pt = build(:product_type)
      lambda do
        pt.age = "unknown"
      end.should_not change(pt, :age)
    end

  end

  describe "admin_deleteable?" do

    it "can be deleted" do
      product_type = build(:product_type)
      product_type.should be_admin_deleteable
    end

    it "can't be deleted if there are list items that use it" do
      product_type = build(:product_type)
      list_item = create(:list_item, product_type: product_type)
      product_type.should_not be_admin_deleteable
    end

    it "can't be deleted if it is owned by a user" do
      product_type = build(:product_type, user: build(:user))
      product_type.list_items << build(:list_item)
      product_type.should_not be_admin_deleteable
    end

  end

end
