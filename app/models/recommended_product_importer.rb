require 'csv'

class RecommendedProductImporter
  def initialize(file_name, sleep_time = 0)
    @file_name = file_name
    @sleep_time = sleep_time
  end

  def import!
    CSV.foreach(file_name, headers: true) do |row|
      import_row(row)
    end
  end

  def import
    CSV.foreach(file_name, headers: true) do |row|
      begin
        import_row(row)
      rescue Exception => e
        puts "Error importing row (#{row}): #{e}"
        sleep sleep_time
      end
    end
  end

  private

  def import_row(row)
    RecommendedProductRow.new(row).save!
  end

  def file_name
    @file_name
  end

  def sleep_time
    @sleep_time
  end
end
