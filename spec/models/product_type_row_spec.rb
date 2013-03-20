require 'spec_helper'
require 'csv'

describe ProductTypeRow do

  let(:category) { create(:category) }

  def row_csv(name = "Shampoo or Body Wash")
    CSV.parse("#{name},0-3 mo,2,shampoo.png,shampoo@2x.png,shampoo;body wash; baby wash,,x,x", headers: false).flatten
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
    product_type_row.name == 'Shampoo or Body Wash'
  end

  it "finds age range name" do
    product_type_row.age_range_name.should == '0-3 mo'
  end

  it "finds priority" do
    product_type_row.priority.should == 2
  end

  it "finds image name" do
    product_type_row.image_name.should == 'shampoo@2x.png'
  end

  it "finds queries" do
    product_type_row.queries.should == [ 'shampoo', 'body wash', 'baby wash' ]
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

  it "sets product type queries" do
    ptrow = ProductTypeRow.new(category, row_csv('whatever'))
    product_type = ptrow.product_type

    ptrow.queries.each do |query|
      product_type.should_receive(:add_query).with(query)
    end

    ptrow.save!
  end

end

