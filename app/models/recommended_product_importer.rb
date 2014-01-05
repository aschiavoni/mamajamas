require 'csv'

class RecommendedProductImporter
  def initialize(file_name, sleep_time = 0)
    @file_name = file_name
    @sleep_time = sleep_time
  end

  def import
    CSV.foreach(file_name, headers: true) do |row|
      RecommendedProductRow.new(row).save!
      sleep sleep_time
    end
  end

  private

  def file_name
    @file_name
  end

  def sleep_time
    @sleep_time
  end
end
