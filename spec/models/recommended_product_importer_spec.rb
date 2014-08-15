# require 'spec_helper'

describe RecommendedProductImporter, :type => :model do

  let(:csv_file) do
    File.join(Dir.pwd, 'spec', 'data',
              'recommended_products', 'recommended_products.csv')
  end

  def importer
    RecommendedProductImporter.new(csv_file)
  end

  it "initializes with file" do
    importer
  end

  it "imports csv" do
    importer.import
  end

end
