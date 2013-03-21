require 'spec_helper'

describe ListBuilder do

  let(:user) { build(:user) }

  let(:builder) { ListBuilder.new(user) }

  before(:all) do
    c = Category.find("potty-training") rescue nil
    create(:category, name: "Potty Training") if c.blank?
  end

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

  describe "with kid" do

    let(:potty_training) do
      Category.find("potty-training")
    end

    let(:product_types) do
      [
        build(:product_type, age_range: AgeRange.pre_birth),
        build(:product_type, age_range: AgeRange.zero_to_three_months),
        build(:product_type, age_range: AgeRange.thirteen_to_eighteen_months),
        build(:product_type, age_range: AgeRange.two_years),
        build(:product_type, age_range: AgeRange.three_years),
        build(:product_type, age_range: AgeRange.four_years),
        build(:product_type,
              age_range: AgeRange.thirteen_to_eighteen_months,
              category: potty_training),
        build(:product_type,
              age_range: AgeRange.two_years,
              category: potty_training)
      ]
    end

    describe "skips placeholders" do

      it "for product types with younger ages" do
        kid = build(:kid, age_range: AgeRange.thirteen_to_eighteen_months)
        builder = ListBuilder.new(user, kid)

        list = builder.build!(product_types)

        ages = list.list_items.map(&:age_range)
        [ AgeRange.pre_birth, AgeRange.zero_to_three_months ].each do |age|
          ages.should_not include(age)
        end
      end

      it "for product types > 13-18 mos for newborns" do
        kid = build(:kid, age_range: AgeRange.zero_to_three_months)
        builder = ListBuilder.new(user, kid)

        list = builder.build!(product_types)

        ages = list.list_items.map(&:age_range)
        [ AgeRange.two_years, AgeRange.three_years, AgeRange.four_years ].each do |age|
          ages.should_not include(age)
        end
      end

      it "for product types > 2y for infants" do
        kid = build(:kid, age_range: AgeRange.four_to_six_months)
        builder = ListBuilder.new(user, kid)

        list = builder.build!(product_types)

        ages = list.list_items.map(&:age_range)
        [ AgeRange.three_years, AgeRange.four_years ].each do |age|
          ages.should_not include(age)
        end
      end

      it "for product types in potty training category if kid is <= 13-18 mos" do
        kid = build(:kid, age_range: AgeRange.pre_birth)
        builder = ListBuilder.new(user, kid)

        list = builder.build!(product_types)

        categories = list.list_items.map(&:category)
        categories.should_not include(potty_training)
      end

    end

  end

  describe "with no kid" do

    it "should add list item placeholders" do
      product_types = build_list(:product_type, 3)
      List.any_instance.
        should_receive(:add_list_item_placeholder).
        exactly(product_types.size).times
      list = builder.build!(product_types)
    end

  end

end
