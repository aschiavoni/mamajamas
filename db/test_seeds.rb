AgeRangeCreator.create!

product_types = {
  "Bathing" =>
  [
    { name: "Shampoo or Body Wash", age_range: "0-3 mo", priority: 2, image_name: "shampoo.png", queries: [ "shampoo", "body wash", "baby wash" ] }
  ],

  "Birthing / Pregnancy" =>
  [
    { name: "Pregnancy Book", age_range: "Pre-birth", priority: 2, image_name: "pregnancy_book@2x.png" }
  ],

  "Changing" =>
  [
    { name: "Disposable Diapers", age_range: "Pre-birth", priority: 1, image_name: nil }
  ],

  "Feeding" =>
  [
    { name: "Wipeable Bib", age_range: "7-12 mo", priority: 1, image_name: "wipeable_bib@2x.png" }
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
        plural_name: "#{product_type_attrs[:name].pluralize}",
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
