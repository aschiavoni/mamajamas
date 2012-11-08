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
    { name: "Shampoo or Body Wash", buy_before: "0-3 mo", priority: 2 },
    { name: "Bath Tub", buy_before: "Pre-birth", priority: 2 },
    { name: "Wash Cloth", buy_before: "Pre-birth", priority: 2 },
    { name: "Towel", buy_before: "Pre-birth", priority: 2 },
    { name: "Bath Seat", buy_before: "7-12 mo", priority: 3 },
    { name: "Bath Mat", buy_before: "4-6 mo", priority: 3 },
    { name: "Bath Book", buy_before: "7-12 mo", priority: 2 },
    { name: "Bath Stool or Kneeler", buy_before: "4-6 mo", priority: 3 },
    { name: "Faucet Cover", buy_before: "7-12 mo", priority: 3 },
    { name: "Rinse Cup or Visor", buy_before: "4-6 mo", priority: 2 },
    { name: "Bath Toy", buy_before: "4-6 mo", priority: 1 },
    { name: "Bath Toy Storage", buy_before: "4-6 mo", priority: 2 },
    { name: "Bath Thermometer", buy_before: "Pre-birth", priority: 3 },
    { name: "Bath Rail or Handle", buy_before: "Pre-birth", priority: 3 }
  ],
  "Birthing / Pregnancy" =>
  [
    { name: "Pregnancy Book", buy_before: "Pre-birth", priority: 2 },
    { name: "Anti-Nausea Remedy", buy_before: "Pre-birth", priority: 2 },
    { name: "Birthing Ball", buy_before: "Pre-birth", priority: 2 },
    { name: "Maternity Shirt", buy_before: "Pre-birth", priority: 1 },
    { name: "Maternity Pants", buy_before: "Pre-birth", priority: 1 },
    { name: "Maternity/Nursing Bra", buy_before: "Pre-birth", priority: 1 },
    { name: "Maternity Leggings", buy_before: "Pre-birth", priority: 3 },
    { name: "Maternity Dress", buy_before: "Pre-birth", priority: 2 },
    { name: "Birthing Gown", buy_before: "Pre-birth", priority: 3 },
    { name: "Maternity Pillow", buy_before: "Pre-birth", priority: 2 },
    { name: "Belly Cast Kit", buy_before: "Pre-birth", priority: 3 }
  ],
  "Changing" =>
  [
    { name: "Disposable Diapers", buy_before: "Pre-birth", priority: 1 },
    { name: "Cloth Diapers", buy_before: "Pre-birth", priority: 1 },
    { name: "Wipes", buy_before: "Pre-birth", priority: 1 },
    { name: "Changing Pad", buy_before: "Pre-birth", priority: 2 },
    { name: "Diaper Cream or Ointment", buy_before: "Pre-birth", priority: 1 },
    { name: "Diaper Pail", buy_before: "Pre-birth", priority: 1 },
    { name: "Wet Bag", buy_before: "Pre-birth", priority: 3 },
    { name: "Wipes Warmer", buy_before: "Pre-birth", priority: 3 },
    { name: "Changing Table", buy_before: "Pre-birth", priority: 2 },
    { name: "Changing Table Pad", buy_before: "Pre-birth", priority: 1 },
    { name: "Changing Table Pad Cover", buy_before: "Pre-birth", priority: 1 }
  ]
}

product_types.each do |category, product_types|
  category = Category.find_or_create_by_name!(category)
  product_types.each do |product_type_attrs|
    ProductType.create!(product_type_attrs.merge({
      category_id: category.id
    }))
  end
end
