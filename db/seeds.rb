# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#

when_to_buy_suggestions = [
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

when_to_buy_suggestions.each_with_index do |when_to_buy, position|
  suggestion = WhenToBuySuggestion.find_by_name(when_to_buy)
  if suggestion.blank?
    WhenToBuySuggestion.create!(name: when_to_buy, position: position)
  else
    suggestion.update_attributes!(position: position)
  end
end

product_types = {
  "Bathing" =>
  [
    { name: "Shampoo or Body Wash", when_to_buy: "0-3 mo", priority: 2, image_name: "shampoo.png", queries: [ "shampoo", "body wash", "baby wash" ] },
    { name: "Bath Tub", when_to_buy: "Pre-birth", priority: 2, image_name: nil, queries: [ "tub", "bather", "bath pad", "bath center", "bathtub", "bath tub" ] },
    { name: "Wash Cloth", when_to_buy: "Pre-birth", priority: 2, image_name: "washcloth_1.png", queries: [ "washcloth", "washcloths", "wash cloths", "wash cloth", ]},
    { name: "Towel", when_to_buy: "Pre-birth", priority: 2, image_name: "towel_2.png", queries: [ "towel", "towels", "terry robe" ] },
    { name: "Bath Seat", when_to_buy: "7-12 mo", priority: 3, image_name: nil, queries: [ "bath seat", "bath ring", "bathing seat", "seat" ] },
    { name: "Bath Mat", when_to_buy: "4-6 mo", priority: 3, image_name: "bath_mat2.png", queries: [ "bath mat", "safety mat", "mat", "bath pad" ] },
    { name: "Bath Book", when_to_buy: "7-12 mo", priority: 2, image_name: nil, queries: [ "bath book", "bath book", "bubble book" ] },
    { name: "Bath Stool or Kneeler", when_to_buy: "4-6 mo", priority: 3, image_name: nil, queries: [ "bath stool", "kneeler", "bath seat", "bath pad" ] },
    { name: "Faucet Cover", when_to_buy: "7-12 mo", priority: 3, image_name: "faucet_cover.png", queries: [ "faucet cover", "spout cover", "spout guard", "faucet guard", "faucet extender" ] },
    { name: "Rinse Cup or Visor", when_to_buy: "4-6 mo", priority: 2, image_name: "rinse_cup.png", queries: [ "rinse cup", "shampoo rinser", "splashguard", "rinser", "bath visor" ]},
    { name: "Bath Toy", when_to_buy: "4-6 mo", priority: 1, image_name: nil, queries: [ "bath toy", "bath toys", "squirters", "squirt toys", "bath letters", "bathtub toy", "bathtub toys" ] },
    { name: "Bath Toy Storage", when_to_buy: "4-6 mo", priority: 2, image_name: nil, queries: [ "bath storage", "bath toy organizer", "bath toy bag", "toy hammock", "bath toy scoop", "bath toy holder" ] },
    { name: "Bath Thermometer", when_to_buy: "Pre-birth", priority: 3, image_name: nil, queries: [ "bath thermometer" ] },
    { name: "Bath Rail or Handle", when_to_buy: "Pre-birth", priority: 3, image_name: nil, queries: [ "bath rail", "bath handle", "bath safety", "safer grip" ] }
  ],
  "Birthing / Pregnancy" =>
  [
    { name: "Pregnancy Book", when_to_buy: "Pre-birth", priority: 2, image_name: "pregnancy_book.png" },
    { name: "Anti-Nausea Remedy", when_to_buy: "Pre-birth", priority: 2, image_name: "anti_nausea_remedy_2.png", queries: [ "anti nausea", "nausea remedy", "nausea" ] },
    { name: "Birthing Ball", when_to_buy: "Pre-birth", priority: 2, image_name: "birthing_ball.png", queries: [ "birthing ball", "birth ball" ] },
    { name: "Maternity Shirt", when_to_buy: "Pre-birth", priority: 1, image_name: "maternity_shirt.png" },
    { name: "Maternity Pants", when_to_buy: "Pre-birth", priority: 1, image_name: "maternity_pants_1.png" },
    { name: "Maternity/Nursing Bra", when_to_buy: "Pre-birth", priority: 1, image_name: nil, queries: [ "maternity bra", "nursing bra" ] },
    { name: "Maternity Leggings", when_to_buy: "Pre-birth", priority: 3, image_name: "maternity_leggings_1.png" },
    { name: "Maternity Dress", when_to_buy: "Pre-birth", priority: 2, image_name: "maternity_dress_1.png" },
    { name: "Birthing Gown", when_to_buy: "Pre-birth", priority: 3, image_name: "birthing_gown_1.png" },
    { name: "Maternity Pillow", when_to_buy: "Pre-birth", priority: 2, image_name: "maternity_pillow.png" },
    { name: "Belly Cast Kit", when_to_buy: "Pre-birth", priority: 3, image_name: "belly_cast_kit.png", queries: [ "belly cast", "belly cast kit" ] }
  ],
  "Changing" =>
  [
    { name: "Disposable Diapers", when_to_buy: "Pre-birth", priority: 1, image_name: nil },
    { name: "Cloth Diapers", when_to_buy: "Pre-birth", priority: 1, image_name: nil },
    { name: "Wipes", when_to_buy: "Pre-birth", priority: 1, image_name: nil },
    { name: "Changing Pad", when_to_buy: "Pre-birth", priority: 2, image_name: nil },
    { name: "Diaper Cream or Ointment", when_to_buy: "Pre-birth", priority: 1, image_name: nil, queries: [ "diaper cream", "diaper ointment" ] },
    { name: "Diaper Pail", when_to_buy: "Pre-birth", priority: 1, image_name: nil },
    { name: "Wet Bag", when_to_buy: "Pre-birth", priority: 3, image_name: nil },
    { name: "Wipes Warmer", when_to_buy: "Pre-birth", priority: 3, image_name: nil },
    { name: "Changing Table", when_to_buy: "Pre-birth", priority: 2, image_name: nil },
    { name: "Changing Table Pad", when_to_buy: "Pre-birth", priority: 1, image_name: nil },
    { name: "Changing Table Pad Cover", when_to_buy: "Pre-birth", priority: 1, image_name: nil }
  ]
}

product_types.each do |category, product_type_hash|
  category = Category.find_or_create_by_name!(category)
  product_type_hash.each do |product_type_attrs|
    when_to_buy_suggestion = WhenToBuySuggestion.find_by_name(product_type_attrs.delete(:when_to_buy))
    queries = product_type_attrs.delete(:queries) || [ product_type_attrs[:name].downcase ]
    product_type = ProductType.find_by_name(product_type_attrs[:name])
    if product_type.blank?
      product_type = ProductType.create!(product_type_attrs.merge({
        category_id: category.id,
        when_to_buy_suggestion_id: when_to_buy_suggestion.id
      }), without_protection: true)
    else
      product_type.update_attributes!(product_type_attrs.merge({
        category_id: category.id,
        when_to_buy_suggestion_id: when_to_buy_suggestion.id
      }), without_protection: true)
    end

    queries.each do |query|
      unless product_type.has_query?(query)
        product_type.queries.create(query: query)
      end
    end
  end
end
