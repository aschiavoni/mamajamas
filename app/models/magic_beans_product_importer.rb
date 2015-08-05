require 'csv'
require 'set'

class MagicBeansProductImporter
  attr_reader :file_name
  attr_reader :product_type_names, :categories, :sub_categories

  def initialize(file_name)
    @file_name = file_name
    @imported = false
    @product_type_names = Set.new
    @categories = Set.new
    @sub_categories = Set.new
  end

  def import
    return if @imported

    each_row do |row|
      product_row = MagicBeansProductImporterRow.new(row)
      @product_type_names << (product_row.product_type_name || "")
      @categories << [
                      product_row.main_category,
                      product_row.sub_category,
                      product_row.product_type_name
                     ].reject { |i| i.blank? }
      @sub_categories << product_row.sub_category
      product_row.save!
    end

    @imported = true
  end

  def valid?
    # verify that the whole file can be read by CSV
    # verify that there are the same # of fields in each row
    field_counts = Set.new
    begin
      each_row do |row|
        field_counts << row.size
      end
      field_counts.size == 1
    rescue Exception
      false
    end
  end

  private

  def each_row
    CSV.foreach(file_name, col_sep: "|", quote_char: "\x00") do |row|
      yield row
    end
  end
end
