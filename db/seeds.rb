# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#

product_types = {
  "Bathing" =>
  [
    { name: "Shampoo or Body Wash", buy_before: "0-3 mo", priority: 2, image_name: "shampoo.png" },
    { name: "Bath Tub", buy_before: "Pre-birth", priority: 2, image_name: nil },
    { name: "Wash Cloth", buy_before: "Pre-birth", priority: 2, image_name: "washcloth_1.png" },
    { name: "Towel", buy_before: "Pre-birth", priority: 2, image_name: "towel_2.png" },
    { name: "Bath Seat", buy_before: "7-12 mo", priority: 3, image_name: nil },
    { name: "Bath Mat", buy_before: "4-6 mo", priority: 3, image_name: "bath_mat2.png" },
    { name: "Bath Book", buy_before: "7-12 mo", priority: 2, image_name: nil },
    { name: "Bath Stool or Kneeler", buy_before: "4-6 mo", priority: 3, image_name: nil },
    { name: "Faucet Cover", buy_before: "7-12 mo", priority: 3, image_name: "faucet_cover.png" },
    { name: "Rinse Cup or Visor", buy_before: "4-6 mo", priority: 2, image_name: "rinse_cup.png" },
    { name: "Bath Toy", buy_before: "4-6 mo", priority: 1, image_name: nil },
    { name: "Bath Toy Storage", buy_before: "4-6 mo", priority: 2, image_name: nil },
    { name: "Bath Thermometer", buy_before: "Pre-birth", priority: 3, image_name: nil },
    { name: "Bath Rail or Handle", buy_before: "Pre-birth", priority: 3, image_name: nil }
  ],
  "Birthing / Pregnancy" =>
  [
    { name: "Pregnancy Book", buy_before: "Pre-birth", priority: 2, image_name: "pregnancy_book.png" },
    { name: "Anti-Nausea Remedy", buy_before: "Pre-birth", priority: 2, image_name: "anti_nausea_remedy_2.png" },
    { name: "Birthing Ball", buy_before: "Pre-birth", priority: 2, image_name: "birthing_ball.png" },
    { name: "Maternity Shirt", buy_before: "Pre-birth", priority: 1, image_name: "maternity_shirt.png" },
    { name: "Maternity Pants", buy_before: "Pre-birth", priority: 1, image_name: "maternity_pants_1.png" },
    { name: "Maternity/Nursing Bra", buy_before: "Pre-birth", priority: 1, image_name: nil },
    { name: "Maternity Leggings", buy_before: "Pre-birth", priority: 3, image_name: "maternity_leggings_1.png" },
    { name: "Maternity Dress", buy_before: "Pre-birth", priority: 2, image_name: "maternity_dress_1.png" },
    { name: "Birthing Gown", buy_before: "Pre-birth", priority: 3, image_name: "birthing_gown_1.png" },
    { name: "Maternity Pillow", buy_before: "Pre-birth", priority: 2, image_name: "maternity_pillow.png" },
    { name: "Belly Cast Kit", buy_before: "Pre-birth", priority: 3, image_name: "belly_cast_kit.png" }
  ],
  "Changing" =>
  [
    { name: "Disposable Diapers", buy_before: "Pre-birth", priority: 1, image_name: nil },
    { name: "Cloth Diapers", buy_before: "Pre-birth", priority: 1, image_name: nil },
    { name: "Wipes", buy_before: "Pre-birth", priority: 1, image_name: nil },
    { name: "Changing Pad", buy_before: "Pre-birth", priority: 2, image_name: nil },
    { name: "Diaper Cream or Ointment", buy_before: "Pre-birth", priority: 1, image_name: nil },
    { name: "Diaper Pail", buy_before: "Pre-birth", priority: 1, image_name: nil },
    { name: "Wet Bag", buy_before: "Pre-birth", priority: 3, image_name: nil },
    { name: "Wipes Warmer", buy_before: "Pre-birth", priority: 3, image_name: nil },
    { name: "Changing Table", buy_before: "Pre-birth", priority: 2, image_name: nil },
    { name: "Changing Table Pad", buy_before: "Pre-birth", priority: 1, image_name: nil },
    { name: "Changing Table Pad Cover", buy_before: "Pre-birth", priority: 1, image_name: nil }
  ]
}

product_types.each do |category, product_types|
  category = Category.find_or_create_by_name!(category)
  product_types.each do |product_type_attrs|
    product_type = ProductType.find_by_name(product_type_attrs[:name])
    if product_type.blank?
      ProductType.create!(product_type_attrs.merge({
        category_id: category.id
      }), without_protection: true)
    else
      product_type.update_attributes!(product_type_attrs.merge({
        category_id: category.id
      }), without_protection: true)
    end
  end
end
