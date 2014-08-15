require 'spec_helper'
require 'csv'

describe RecommendedProductRow, :type => :model do

  def default_link(tag)
    "http://www.amazon.com/My-Brest-Friend-Pillow-Sunburst-#{tag}/dp/B000HZEQSU%3FSubscriptionId%3DAKIAIXAEIBVZBZEU56MQ%26tag%3Dmamajamas-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3DB000HZEQSU"
  end

  def row_csv(name = "Nursing Pillow", plural_name = "Nursing Pillows", link = default_link('none'))
    CSV.parse("18,Nursing,#{name},#{plural_name},1,nursing-pillow,products/icons/nursing_pillow@2x.png,0-3 mo,All,,1,2013-06-27 13:56:27 UTC,Nursing Pillow Eco Name,#{default_link('eco')},My Brest Friend Pillow,#{default_link('upscale')},Nursing Pillow Cost Conscious Name,#{default_link('cost')},Nursing Pillow Extra Name,#{default_link('extra')},Nursing Pillow Twins Name,#{default_link('twins')}").flatten
  end

  def row_csv_no_upscale(name = "Nursing Pillow", plural_name = "Nursing Pillows", link = default_link('none'))
    CSV.parse("18,Nursing,#{name},#{plural_name},1,nursing-pillow,products/icons/nursing_pillow@2x.png,0-3 mo,All,,1,2013-06-27 13:56:27 UTC,Nursing Pillow Eco Name,#{default_link('eco')},My Brest Friend Pillow,,Nursing Pillow Cost Conscious Name,#{default_link('cost')},Nursing Pillow Extra Name,#{default_link('extra')},Nursing Pillow Twins Name,#{default_link('twins')}").flatten
  end

  def row_csv_no_name
   CSV.parse(',,,,,,,,').flatten
  end

  def recommended_product_row(row_csv = row_csv)
    RecommendedProductRow.new(row_csv)
  end

  def create_product_type(name)
    pt = ProductType.find_by_name(name)
    if pt.blank?
      pt = ProductType.create!(name: name, plural_name: name.pluralize)
    end
    pt
  end

  it "finds product type name" do
    expect(recommended_product_row.name).to eq('Nursing Pillow')
  end

  it "finds eco name" do
    expect(recommended_product_row.eco_name).to eq("Nursing Pillow Eco Name")
  end

  it "finds eco link" do
    expect(recommended_product_row.eco_link).to eq(default_link("eco"))
  end

  it "finds upscale name" do
    expect(recommended_product_row.upscale_name).to eq("My Brest Friend Pillow")
  end

  it "finds upscale link" do
    expect(recommended_product_row.upscale_link).to eq(default_link("upscale"))
  end

  it "finds cost conscious name" do
    expect(recommended_product_row.cost_name).to eq(
      "Nursing Pillow Cost Conscious Name"
    )
  end

  it "finds cost conscious link" do
    expect(recommended_product_row.cost_link).to eq(default_link("cost"))
  end

  it "finds extra name" do
    expect(recommended_product_row.extra_name).to eq("Nursing Pillow Extra Name")
  end

  it "finds extra link" do
    expect(recommended_product_row.extra_link).to eq(default_link("extra"))
  end

  it "finds twins name" do
    expect(recommended_product_row.twins_name).to eq("Nursing Pillow Twins Name")
  end

  it "finds twins link" do
    expect(recommended_product_row.twins_link).to eq(default_link("twins"))
  end

  it "retrieves product type associated with row" do
    pt = create_product_type("Nursing Pillow")
    expect(recommended_product_row.product_type).to eq(pt)
  end

  it "builds recommended product service update hash" do
    create_product_type("Nursing Pillow")
    expected = [ :eco, :upscale, :cost, :extra, :twins ]
    expect(recommended_product_row.update_hash.keys).to include(*expected)
  end

  it "builds recommended product service update hash without upscale link" do
    create_product_type("Nursing Pillow")
    expected = [ :eco, :cost, :extra, :twins ]
    expect(recommended_product_row(row_csv_no_upscale).
      update_hash.keys).to include(*expected)
  end

  it "saves recommended products" do
    create_product_type("Nursing Pillow")
    expect(RecommendedProductService).
      to receive(:create_or_update!).
      with(recommended_product_row.update_hash)
    recommended_product_row.save!
  end

end
