namespace :mamajamas do

  namespace :product_types do

    namespace :import do

      desc 'Imports mamajamas categories and product types from csvs'
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

  namespace :recommended_products do

    namespace :import do

      desc "Imports recommended products from a csv"
      task csv: :environment do
        file = ENV["FILE"]
        puts file

        raise "File does not exist" unless file.present? && File.exist?(file)

        importer = RecommendedProductImporter.new(file, 0.5)
        puts "Importing #{File.basename(file)}..."
        importer.import
        puts "Done."
      end

    end

  end

end
