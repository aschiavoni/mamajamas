require 'spec_helper'

describe MagicBeansProductImporter do

  let(:import_file) do
    # File.expand_path("~/Downloads/27456.txt")
    File.join(Dir.pwd, 'spec', 'data', 'magic_beans.txt')
  end

  def importer
    @importer = MagicBeansProductImporter.new(import_file)
  end

  it "initializes with file" do
    importer
  end

  it "validates import file" do
    expect(importer).to be_valid
  end

  it "imports file" do
    importer.import
  end

  it "retrieves a unique set of product type names" do
    importer.import
    expect(@importer.product_type_names).to_not be_empty
  end

end
