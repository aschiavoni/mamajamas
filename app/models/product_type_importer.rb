require 'csv'

class ProductTypeImporter
  def initialize(file_name)
    @file_name = file_name
  end

  def import
    CSV.foreach(file_name, headers: true) do |row|
      ProductTypeRow.new(category, row).save!
    end
  end

  def category_name
    @category_name ||= File.basename(file_name.gsub(File.extname(file_name), ''))
  end

  def category
    @category ||= Category.find_or_create_by!(name: category_name)
  end

  private

  def file_name
    @file_name
  end
end
