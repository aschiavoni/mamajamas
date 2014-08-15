require 'spec_helper'

describe ListItem, :type => :model do

  describe "is valid" do

    it "must have a name" do
      list_item = build(:list_item, name: nil)
      expect(list_item).not_to be_valid
    end

    it "must have a link" do
      list_item = build(:list_item, link: nil)
      expect(list_item).not_to be_valid
    end

    it "does not need a name if it is a placeholder" do
      list_item = build(:list_item, placeholder: true, name: nil)
      expect(list_item).to be_valid
    end

    it "does not need a link if it is a placeholder" do
      list_item = build(:list_item, placeholder: true, link: nil)
      expect(list_item).to be_valid
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

  describe "age range" do

    let(:age_range) { build(:age_range) }

    it "should return age range name" do
      li = build(:list_item, age_range: age_range)
      expect(li.age).to eq(age_range.name)
    end

    it "should set age range from name" do
      li = build(:list_item)
      expect(AgeRange).to receive(:find_by_name).with(age_range.name).and_return(age_range)
      li.age = age_range.name
      expect(li.age).to eq(age_range.name)
    end

    it "should not change age range with an unknown name" do
      li = build(:list_item)
      expect do
        li.age = "unknown"
      end.not_to change(li, :age)
    end

  end

  describe "unique products" do

    before(:all) do
      create(:list_item, vendor: "amazon", vendor_id: "1234")
      create(:list_item, vendor: "amazon", vendor_id: "1234")
      create(:list_item, vendor: "soap.com", vendor_id: "54321")
    end

    it "returns a unique list of vendor and vendor id combos" do
      products = [["1234", "amazon" ], [ "54321", "soap.com" ]]
      products.each do |product_data|
        expect(ListItem.unique_products).to include(product_data)
      end
    end

  end

  describe "no image url" do

    it "returns product type image name" do
      list_item = build(:list_item, image_url: nil)
      expect(list_item.image_url).to eq(list_item.product_type.image_name)
    end

    it "returns product type image name when image url empty" do
      list_item = build(:list_item, image_url: "")
      expect(list_item.image_url).to eq(list_item.product_type.image_name)
    end

    it "returns unknown image name if product type not found" do
      list_item = build(:list_item, product_type: nil, image_url: nil)
      expect(list_item.image_url).to eq("products/icons/unknown.png")
    end

  end

end
