# require 'spec_helper'

describe ProductTypeImporter, :type => :model do

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
    expect(importer.category_name).to eq('Clothing')
  end

  it "finds category" do
    expect(importer.category).not_to be_nil
  end

  it "imports csv" do
    importer.import
  end

end
