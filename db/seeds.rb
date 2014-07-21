# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#

AgeRangeCreator.create!

other_params = {
  name: 'Other',
  priority: 2,
  image_name: 'products/icons/unknown.png',
  age_range_id: AgeRange.find_by_normalized_name!('Pre-birth').id,
  plural_name: 'Other',
  search_index: nil,
  search_query: nil,
  recommended_quantity: 1,
  active: false
}
other = ProductType.find_by_name(other_params[:name])
if other.blank?
  other = ProductType.create!(other_params)
else
  other.update_attributes!(other_params)
end

csvs = File.join(Rails.root, 'db', 'seeds', '*.csv')
Dir.glob(csvs) do |file_name|
  importer = ProductTypeImporter.new(file_name)
  print "Importing #{File.basename(file_name)}... "
  importer.import
  puts "Done."
end
