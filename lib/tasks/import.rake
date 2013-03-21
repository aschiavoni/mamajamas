namespace :mamajamas do

  namespace :product_types do

    namespace :import do

      task csv: :environment do
        csvs = File.join Dir.pwd, 'db', 'seeds', '*.csv'
        Dir.glob(csvs) do |file_name|
          importer = ProductTypeImporter.new(file_name)
          print "Importing #{File.basename(file_name)}... "
          importer.import
          puts "Done."
        end
      end

    end

  end

end
