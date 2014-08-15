require 'spec_helper'

describe ProductType, :type => :model do

  describe "global" do

    it "should include global product types" do
      global_product_type = create(:product_type)
      expect(ProductType.global).to include(global_product_type)
    end

    it "should only include global product types" do
      user_product_type = create(:product_type, user: create(:user))
      expect(ProductType.global).not_to include(user_product_type)
    end

  end

  describe "global active" do

    it "should include global product types" do
      global_product_type = create(:product_type)
      expect(ProductType.global_active).to include(global_product_type)
    end

    it "should not include inactive product types" do
      inactive_product_type = create(:product_type, active: false)
      expect(ProductType.global_active).not_to include(inactive_product_type)
    end
  end

  describe "user" do

    it "should include user product types" do
      user_product_type = create(:product_type, user: create(:user))
      expect(ProductType.user).to include(user_product_type)
    end

    it "should only include user product types" do
      global_product_type = create(:product_type)
      expect(ProductType.user).not_to include(global_product_type)
    end

  end

  describe "by category" do

    it "should query by category if specified" do
      category = double(:category, id: 1)
      expect(subject.class).to receive(:where).with(category_id: category.id)
      subject.class.by_category(category)
    end

    it "should not filter results if category is blank" do
      expect(subject.class).to receive(:all)
      subject.class.by_category(nil)
    end

  end

  describe "image name" do

    let(:product_type) { create(:product_type) }

    it "should return image name" do
      pt = build(:product_type, image_name: "test.png")
      expect(pt.image_name).to eq("test.png")
    end

    it "should return unknown image name when image name is blank" do
      pt = build(:product_type, image_name: nil)
      expect(pt.image_name).to eq("unknown.png")
    end

    it "downcases image name when saved" do
      product_type.image_name = "Heyo.png"
      product_type.save!
      product_type.reload

      expect(product_type.image_name).to eq("heyo.png")
    end

    it "downcases image name when created" do
      product_type = ProductType.create!(
                                         name: "some product type",
                                         plural_name: "some product types",
                                         image_name: "Heyo.png")

      product_type.reload

      expect(product_type.image_name).to eq("heyo.png")
    end

  end

  describe "when to buy" do

    let(:age_range) { create(:age_range) }

    it "should return age range name" do
      pt = build(:product_type, age_range: age_range)
      expect(pt.age).to eq(age_range.name)
    end

    it "should set age range from name" do
      pt = build(:product_type)
      expect(AgeRange).to receive(:find_by_name).with(age_range.name).and_return(age_range)
      pt.age = age_range.name
      expect(pt.age).to eq(age_range.name)
    end

    it "should not change age range with an unknown name" do
      pt = build(:product_type)
      expect do
        pt.age = "unknown"
      end.not_to change(pt, :age)
    end

  end

  describe "admin_deleteable?" do

    it "can be deleted" do
      product_type = build(:product_type)
      expect(product_type).to be_admin_deleteable
    end

    it "can't be deleted if there are list items that use it" do
      product_type = build(:product_type)
      list_item = create(:list_item, product_type: product_type)
      expect(product_type).not_to be_admin_deleteable
    end

    it "can't be deleted if it is owned by a user" do
      product_type = build(:product_type, user: build(:user))
      product_type.list_items << build(:list_item)
      expect(product_type).not_to be_admin_deleteable
    end

  end

end
