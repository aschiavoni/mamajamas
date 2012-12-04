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
    { name: "Shampoo or Body Wash", when_to_buy: "0-3 mo", priority: 2, image_name: "shampoo.png" },
    { name: "Bath Tub", when_to_buy: "Pre-birth", priority: 2, image_name: nil },
    { name: "Wash Cloth", when_to_buy: "Pre-birth", priority: 2, image_name: "washcloth_1.png" },
    { name: "Towel", when_to_buy: "Pre-birth", priority: 2, image_name: "towel_2.png" },
    { name: "Bath Seat", when_to_buy: "7-12 mo", priority: 3, image_name: nil },
    { name: "Bath Mat", when_to_buy: "4-6 mo", priority: 3, image_name: "bath_mat2.png" },
    { name: "Bath Book", when_to_buy: "7-12 mo", priority: 2, image_name: nil },
    { name: "Bath Stool or Kneeler", when_to_buy: "4-6 mo", priority: 3, image_name: nil },
    { name: "Faucet Cover", when_to_buy: "7-12 mo", priority: 3, image_name: "faucet_cover.png" },
    { name: "Rinse Cup or Visor", when_to_buy: "4-6 mo", priority: 2, image_name: "rinse_cup.png" },
    { name: "Bath Toy", when_to_buy: "4-6 mo", priority: 1, image_name: nil },
    { name: "Bath Toy Storage", when_to_buy: "4-6 mo", priority: 2, image_name: nil },
    { name: "Bath Thermometer", when_to_buy: "Pre-birth", priority: 3, image_name: nil },
    { name: "Bath Rail or Handle", when_to_buy: "Pre-birth", priority: 3, image_name: nil }
  ],
  "Birthing / Pregnancy" =>
  [
    { name: "Pregnancy Book", when_to_buy: "Pre-birth", priority: 2, image_name: "pregnancy_book.png" },
    { name: "Anti-Nausea Remedy", when_to_buy: "Pre-birth", priority: 2, image_name: "anti_nausea_remedy_2.png" },
    { name: "Birthing Ball", when_to_buy: "Pre-birth", priority: 2, image_name: "birthing_ball.png" },
    { name: "Maternity Shirt", when_to_buy: "Pre-birth", priority: 1, image_name: "maternity_shirt.png" },
    { name: "Maternity Pants", when_to_buy: "Pre-birth", priority: 1, image_name: "maternity_pants_1.png" },
    { name: "Maternity/Nursing Bra", when_to_buy: "Pre-birth", priority: 1, image_name: nil },
    { name: "Maternity Leggings", when_to_buy: "Pre-birth", priority: 3, image_name: "maternity_leggings_1.png" },
    { name: "Maternity Dress", when_to_buy: "Pre-birth", priority: 2, image_name: "maternity_dress_1.png" },
    { name: "Birthing Gown", when_to_buy: "Pre-birth", priority: 3, image_name: "birthing_gown_1.png" },
    { name: "Maternity Pillow", when_to_buy: "Pre-birth", priority: 2, image_name: "maternity_pillow.png" },
    { name: "Belly Cast Kit", when_to_buy: "Pre-birth", priority: 3, image_name: "belly_cast_kit.png" }
  ],
  "Changing" =>
  [
    { name: "Disposable Diapers", when_to_buy: "Pre-birth", priority: 1, image_name: nil },
    { name: "Cloth Diapers", when_to_buy: "Pre-birth", priority: 1, image_name: nil },
    { name: "Wipes", when_to_buy: "Pre-birth", priority: 1, image_name: nil },
    { name: "Changing Pad", when_to_buy: "Pre-birth", priority: 2, image_name: nil },
    { name: "Diaper Cream or Ointment", when_to_buy: "Pre-birth", priority: 1, image_name: nil },
    { name: "Diaper Pail", when_to_buy: "Pre-birth", priority: 1, image_name: nil },
    { name: "Wet Bag", when_to_buy: "Pre-birth", priority: 3, image_name: nil },
    { name: "Wipes Warmer", when_to_buy: "Pre-birth", priority: 3, image_name: nil },
    { name: "Changing Table", when_to_buy: "Pre-birth", priority: 2, image_name: nil },
    { name: "Changing Table Pad", when_to_buy: "Pre-birth", priority: 1, image_name: nil },
    { name: "Changing Table Pad Cover", when_to_buy: "Pre-birth", priority: 1, image_name: nil }
  ]
}

product_types.each do |category, product_types|
  category = Category.find_or_create_by_name!(category)
  product_types.each do |product_type_attrs|
    when_to_buy_suggestion = WhenToBuySuggestion.find_by_name(product_type_attrs.delete(:when_to_buy))
    product_type = ProductType.find_by_name(product_type_attrs[:name])
    if product_type.blank?
      ProductType.create!(product_type_attrs.merge({
        category_id: category.id,
        when_to_buy_suggestion_id: when_to_buy_suggestion.id
      }), without_protection: true)
    else
      product_type.update_attributes!(product_type_attrs.merge({
        category_id: category.id,
        when_to_buy_suggestion_id: when_to_buy_suggestion.id
      }), without_protection: true)
    end
  end
end
