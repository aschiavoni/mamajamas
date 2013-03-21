# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#

AgeRangeCreator.create!

csvs = File.join(Rails.root, 'db', 'seeds', '*.csv')
Dir.glob(csvs) do |file_name|
  importer = ProductTypeImporter.new(file_name)
  print "Importing #{File.basename(file_name)}... "
  importer.import
  puts "Done."
end
