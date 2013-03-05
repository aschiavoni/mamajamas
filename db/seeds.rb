# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#

age_ranges = [
  "Pre-birth",
  "0-3 mo",
  "4-6 mo",
  "7-12 mo",
  "13-18 mo",
  "19-24 mo",
  "2y",
  "3y",
  "4y",
  "5y+"
]

age_ranges.each_with_index do |age, position|
  age_range = AgeRange.find_by_name(age)
  if age_range.blank?
    AgeRange.create!(name: age, position: position)
  else
    age_range.update_attributes!(position: position)
  end
end

product_types = {
  "Bathing" =>
  [
    { name: "Shampoo or Body Wash", age_range: "0-3 mo", priority: 2, image_name: "shampoo.png", queries: [ "shampoo", "body wash", "baby wash" ] },
    { name: "Bath Tub", age_range: "Pre-birth", priority: 2, image_name: nil, queries: [ "tub", "bather", "bath pad", "bath center", "bathtub", "bath tub" ] },
    { name: "Wash Cloth", age_range: "Pre-birth", priority: 2, image_name: "washcloth_1.png", queries: [ "washcloth", "washcloths", "wash cloths", "wash cloth", ]},
    { name: "Towel", age_range: "Pre-birth", priority: 2, image_name: "towel_2.png", queries: [ "towel", "towels", "terry robe" ] },
    { name: "Bath Seat", age_range: "7-12 mo", priority: 3, image_name: nil, queries: [ "bath seat", "bath ring", "bathing seat", "seat" ] },
    { name: "Bath Mat", age_range: "4-6 mo", priority: 3, image_name: "bath_mat2.png", queries: [ "bath mat", "safety mat", "mat", "bath pad" ] },
    { name: "Bath Book", age_range: "7-12 mo", priority: 2, image_name: nil, queries: [ "bath book", "bath book", "bubble book" ] },
    { name: "Bath Stool or Kneeler", age_range: "4-6 mo", priority: 3, image_name: nil, queries: [ "bath stool", "kneeler", "bath seat", "bath pad" ] },
    { name: "Faucet Cover", age_range: "7-12 mo", priority: 3, image_name: "faucet_cover.png", queries: [ "faucet cover", "spout cover", "spout guard", "faucet guard", "faucet extender" ] },
    { name: "Rinse Cup or Visor", age_range: "4-6 mo", priority: 2, image_name: "rinse_cup.png", queries: [ "rinse cup", "shampoo rinser", "splashguard", "rinser", "bath visor" ]},
    { name: "Bath Toy", age_range: "4-6 mo", priority: 1, image_name: nil, queries: [ "bath toy", "bath toys", "squirters", "squirt toys", "bath letters", "bathtub toy", "bathtub toys" ] },
    { name: "Bath Toy Storage", age_range: "4-6 mo", priority: 2, image_name: nil, queries: [ "bath storage", "bath toy organizer", "bath toy bag", "toy hammock", "bath toy scoop", "bath toy holder" ] },
    { name: "Bath Thermometer", age_range: "Pre-birth", priority: 3, image_name: nil, queries: [ "bath thermometer" ] },
    { name: "Bath Rail or Handle", age_range: "Pre-birth", priority: 3, image_name: nil, queries: [ "bath rail", "bath handle", "bath safety", "safer grip" ] }
  ],

  "Birthing / Pregnancy" =>
  [
    { name: "Pregnancy Book", age_range: "Pre-birth", priority: 2, image_name: "pregnancy_book.png" },
    { name: "Anti-Nausea Remedy", age_range: "Pre-birth", priority: 2, image_name: "anti_nausea_remedy_2.png", queries: [ "anti nausea", "nausea remedy", "nausea" ] },
    { name: "Birthing Ball", age_range: "Pre-birth", priority: 2, image_name: "birthing_ball.png", queries: [ "birthing ball", "birth ball" ] },
    { name: "Maternity Shirt", age_range: "Pre-birth", priority: 1, image_name: "maternity_shirt.png" },
    { name: "Maternity Pants", age_range: "Pre-birth", priority: 1, image_name: "maternity_pants_1.png" },
    { name: "Maternity/Nursing Bra", age_range: "Pre-birth", priority: 1, image_name: nil, queries: [ "maternity bra", "nursing bra" ] },
    { name: "Maternity Leggings", age_range: "Pre-birth", priority: 3, image_name: "maternity_leggings_1.png" },
    { name: "Maternity Dress", age_range: "Pre-birth", priority: 2, image_name: "maternity_dress_1.png" },
    { name: "Birthing Gown", age_range: "Pre-birth", priority: 3, image_name: "birthing_gown_1.png" },
    { name: "Maternity Pillow", age_range: "Pre-birth", priority: 2, image_name: "maternity_pillow.png" },
    { name: "Belly Cast Kit", age_range: "Pre-birth", priority: 3, image_name: "belly_cast_kit.png", queries: [ "belly cast", "belly cast kit" ] }
  ],

  "Changing" =>
  [
    { name: "Disposable Diapers", age_range: "Pre-birth", priority: 1, image_name: nil },
    { name: "Cloth Diapers", age_range: "Pre-birth", priority: 1, image_name: nil },
    { name: "Wipes", age_range: "Pre-birth", priority: 1, image_name: nil },
    { name: "Changing Pad", age_range: "Pre-birth", priority: 2, image_name: nil },
    { name: "Diaper Cream or Ointment", age_range: "Pre-birth", priority: 1, image_name: nil, queries: [ "diaper cream", "diaper ointment" ] },
    { name: "Diaper Pail", age_range: "Pre-birth", priority: 1, image_name: nil },
    { name: "Wet Bag", age_range: "Pre-birth", priority: 3, image_name: nil },
    { name: "Wipes Warmer", age_range: "Pre-birth", priority: 3, image_name: nil },
    { name: "Changing Table", age_range: "Pre-birth", priority: 2, image_name: nil },
    { name: "Changing Table Pad", age_range: "Pre-birth", priority: 1, image_name: nil },
    { name: "Changing Table Pad Cover", age_range: "Pre-birth", priority: 1, image_name: nil }
  ],

  "Potty Training" => []
}

product_types.each do |category, product_type_hash|
  category = Category.find_or_create_by_name!(category)
  product_type_hash.each do |product_type_attrs|
    age_range = AgeRange.find_by_name(product_type_attrs.delete(:age_range))
    queries = product_type_attrs.delete(:queries) || [ product_type_attrs[:name].downcase ]
    product_type = ProductType.find_by_name(product_type_attrs[:name])
    if product_type.blank?
      product_type = ProductType.create!(product_type_attrs.merge({
        category_id: category.id,
        age_range_id: age_range.id
      }), without_protection: true)
    else
      product_type.update_attributes!(product_type_attrs.merge({
        category_id: category.id,
        age_range_id: age_range.id
      }), without_protection: true)
    end

    queries.each do |query|
      unless product_type.has_query?(query)
        product_type.queries.create(query: query)
      end
    end
  end
end
