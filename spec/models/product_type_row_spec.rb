require 'spec_helper'
require 'csv'

describe ProductTypeRow do

  let(:category) { create(:category) }

  def row_csv(name = "Bodysuit")
    CSV.parse("#{name},1,Pre-birth,bodysuit.png,bodysuit@2x.png,bodysuit; body suit;body suits,,x,x,,,").flatten
  end

  def row_csv_no_queries(name = "Bodysuit")
    CSV.parse("#{name},1,Pre-birth,bodysuit.png,bodysuit@2x.png,,,x,x,,,").flatten
  end

  def row_csv_no_name
   CSV.parse(',,,,,,,,').flatten
  end

  def row_csv_no_age_range
   CSV.parse('11,,,,,,,,').flatten
  end

  def row_csv_no_priority
   CSV.parse('11,12,,,,,,,').flatten
  end

  def product_type_row
    ProductTypeRow.new(category, row_csv)
  end

  def create_product_type(name)
    pt = ProductType.find_by_name(name)
    if pt.blank?
      pt = ProductType.create!(name: name)
    end
    pt
  end

  it "finds product type name" do
    product_type_row.name == 'Bodysuit'
  end

  it "finds age range name" do
    product_type_row.age_range_name.should == 'Pre-birth'
  end

  it "finds priority" do
    product_type_row.priority.should == 1
  end

  it "finds image name" do
    product_type_row.image_name.should == 'bodysuit@2x.png'
  end

  it "finds queries" do
    product_type_row.queries.should == [ 'bodysuit', 'body suit', 'body suits' ]
  end

  it "finds age range" do
    product_type_row.age_range.should_not be_nil
  end

  it "updates a product type if it does exist" do
    create_product_type('Shampoo or Body Wash')
    ProductType.any_instance.should_receive(:assign_attributes)
    product_type_row.product_type.should_not be_nil
  end

  it "creates a product type if it does not exist" do
    ptrow = ProductTypeRow.new(category, row_csv('whatever'))
    ptrow.product_type.should_not be_nil
  end

  it "saves product types" do
    ptrow = ProductTypeRow.new(category, row_csv('whatever'))
    product_type = ptrow.product_type

    ptrow.queries.each do |query|
      product_type.should_receive(:add_query).with(query)
    end

    ptrow.save!
  end

  it "handles rows without queries" do
    ptrow = ProductTypeRow.new(category, row_csv_no_queries)
    ptrow.queries.should == [ ptrow.name ]
  end

  it "should be a valid row" do
    ptrow = ProductTypeRow.new(category, row_csv)
    ptrow.should be_valid
  end

  it "is invalid if row does not contain a name" do
    ptrow = ProductTypeRow.new(category, row_csv_no_name)
    ptrow.should_not be_valid
  end

  it "is invalid if row does not contain an age range" do
    ptrow = ProductTypeRow.new(category, row_csv_no_age_range)
    ptrow.should_not be_valid
  end

  it "is invalid if row does not contain a priority" do
    ptrow = ProductTypeRow.new(category, row_csv_no_priority)
    ptrow.should_not be_valid
  end

end

