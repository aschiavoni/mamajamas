require 'spec_helper'

describe ListBuilder, :type => :model do

  let(:user) { create(:user) }

  let(:builder) { ListBuilder.new(user) }

  before(:all) do
    c = Category.find("potty-training") rescue nil
    create(:category, name: "Potty Training") if c.blank?
  end

  it "should build list" do
    expect(builder.build!).to be_an_instance_of(List)
  end

  it "should assign list to user" do
    expect(user).to receive(:list=).with(builder.list)
    builder.build!
  end

  it "should save list" do
    expect_any_instance_of(List).to receive(:save!)
    builder.build!
  end

  describe "with kid" do

    let(:potty_training) do
      Category.find("potty-training")
    end

    let(:comparer) { AgeRangeComparer.new }

    let(:product_types) do
      [
        create(:product_type, age_range: comparer.pre_birth),
        create(:product_type, age_range: comparer.zero_to_three_months),
        create(:product_type, age_range: comparer.thirteen_to_eighteen_months),
        create(:product_type, age_range: comparer.two_years),
        create(:product_type, age_range: comparer.three_years),
        create(:product_type, age_range: comparer.four_years),
        create(:product_type,
               age_range: comparer.thirteen_to_eighteen_months,
               category: potty_training),
        create(:product_type,
               age_range: comparer.two_years,
               category: potty_training)
      ]
    end

    describe "skips placeholders" do

      it "for product types > 13-18 mos for newborns" do
        kid = build(:kid, age_range: comparer.zero_to_three_months)
        builder = ListBuilder.new(user, kid)

        list = builder.build!(product_types)

        ages = list.list_items.map(&:age_range)
        [ comparer.two_years, comparer.three_years, comparer.four_years ].each do |age|
          expect(ages).not_to include(age)
        end
      end

      it "for product types > 2y for infants" do
        kid = build(:kid, age_range: comparer.four_to_six_months)
        builder = ListBuilder.new(user, kid)

        list = builder.build!(product_types)

        ages = list.list_items.map(&:age_range)
        [ comparer.three_years, comparer.four_years ].each do |age|
          expect(ages).not_to include(age)
        end
      end

      it "for product types in potty training category if kid is <= 13-18 mos" do
        kid = build(:kid, age_range: comparer.pre_birth)
        builder = ListBuilder.new(user, kid)

        list = builder.build!(product_types)

        categories = list.list_items.map(&:category)
        expect(categories).not_to include(potty_training)
      end

    end

  end

  describe "with no kid" do

    it "should add list item placeholders" do
      product_types = create_list(:product_type, 3)
      expect(List.connection).
        to receive(:execute).
        at_least(product_types.size).times
      list = builder.build!(product_types)
    end

  end

end
