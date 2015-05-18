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

# Add Magic Beans Product Type aliases
map = {
       "Activity Gym"=>["Activity Gyms & Play Mats"],
       "Double Stroller"=>
         ["All-terrain Double Strollers", "Inline & Tandem Double Strollers"],
       "Stroller"=>["All-terrain Single Strollers", "Hybrid Single Strollers"],
       "Baby Food Maker"=>["Baby Food Processors & Storage"],
       "Monitor"=>["Baby Monitors"],
       "Stuffed Animal"=>["Baby Plush", "Stuffed Animals"],
       "Diaper Bag"=>
         ["Backpack Diaper Bags", "Fashion Diaper Bags", "Messenger Diaper Bags"],
       "Hat"=>["Basic Baby Hats", "Spring/Summer Hats"],
       "Bath Toy"=>["Bath Toys"],
       "Cloth Bib"=>["Bibs"],
       "Blanket"=>["Blankets, Swaddling & Sleep Sacks"],
       "Blocks"=>["Blocks"],
       "Bodysuit"=>["Bodysuits"],
       "Booster Seat"=>["Booster Seats", "High Chairs & Booster Seats"],
       "Bottle"=>["Bottles & Burp Cloths"],
       "Bouncy Chair"=>["Bouncers & Rockers"],
       "Breast Pump"=>["Breast Pumps & Accessories"],
       "Building Set"=>
         ["Building & Erector Sets",
          "Building, Sorting & Pounding",
          "LEGO",
          "Magnetic Building",
          "Playmobil"],
       "Music"=>["CDs"],
       "Animals"=>["Calico Critters"],
       "Car Seat Toy"=>["Car Seat & Stroller Toys"],
       "Game"=>["Card Games"],
       "Car or Truck"=>["Cars & Trucks"],
       "Kid Book"=>["Children's Books"],
       "Convertible Car Seat"=>["Convertible Car Seats"],
       "Crib Sheets"=>["Crib Bedding", "Crib Sheets & Mattress Protectors"],
       "Crib Mattress"=>["Crib Mattresses"],
       "Mobile"=>["Crib Mobiles"],
       "Cribs"=>["Cribs & Bassinets"],
       "Diapers"=>["Diapering"],
       "Doll House"=>["Dollhouses & Dollhouse Furniture"],
       "Doll"=>["Dolls"],
       "Changing Table"=>["Dressers, Storage & Changing"],
       "Carrier or Wrap"=>["Front & Back Carriers"],
       "High Chair"=>["High Chairs"],
       "Grasping Toy"=>["Infant Activity Toys"],
       "Infant Car Seat"=>["Infant Car Seats"],
       "Jogging Stroller"=>["Jogging Single Strollers"],
       "Toddler Bed"=>["Kids Beds, Conversion Kits & Bed Rails"],
       "Helmet"=>["Kids' Helmets"],
       "Umbrella Stroller"=>["Lightweight Single Strollers"],
       "Nursing Bra"=>["Nursing Bras & Covers"],
       "Rocking Chair or Glider"=>["Nursing Chairs & Ottomans"],
       "Nursing Pillow"=>["Nursing Pillows & Slip Covers"],
       "Swing set"=>["Outdoor Play Sets"],
       "Outerwear"=>["Outerwear"],
       "Sleepwear"=>["Pajamas"],
       "Pants"=>["Pants"],
       "Puppet"=>["Puppets"],
       "Push Toy"=>["Pushing & Pulling"],
       "Puzzle"=>["Puzzles"],
       "Teether"=>["Rattles & Teethers"],
       "Ride-On Toy"=>["Rockers & Ride-Ons"],
       "Romper"=>["Rompers & Footies"],
       "Shoes"=>["Shoes"],
       "Sling"=>["Slings"],
       "Shampoo or Bodywash"=>["Soaps & Shampoos"],
       "Socks"=>["Socks"],
       "Stickers"=>["Stickers"],
       "Stroller Bunting Bag"=>["Stroller Footmuffs & Seat Liners"],
       "Sunglasses"=>["Sunglasses"],
       "Swaddle Blanket"=>["Swaddling & Sleep Sacks"],
       "Train Set"=>["Trains & Tracks"],
       "Travel Crib"=>["Travel Cribs & Play Pens"],
       "Bicycle"=>["Trikes & Bikes"]
      }

map.each do |product_type_name, aliases|
  pt = ProductType.find_by(name: product_type_name)
  if pt.present?
    alias_set = Set.new(pt.aliases || [])
    aliases.each do |a| alias_set << a; end
    pt.aliases = alias_set.to_a
    pt.save!
  end
end
