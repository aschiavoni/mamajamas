# require 'spec_helper'

describe ProductTypeImporter do

  let(:csv_file) do
    File.join(Dir.pwd, 'db', 'seeds', 'Clothing.csv')
  end

  def importer
    ProductTypeImporter.new(csv_file)
  end

  it "initializes with file" do
    importer
  end

  it "finds category name" do
    importer.category_name.should == 'Clothing'
  end

  it "finds category" do
    importer.category.should_not be_nil
  end

  it "imports csv" do
    importer.import
  end

end
