class ProductTypeRow
  attr_reader :category

  def initialize(category, csv_row)
    @row = csv_row
    @category = category
  end

  def valid?
    name.present? && age_range_name.present? && priority.present?
  end

  def name
    row[0]
  end

  def plural_name
    row[1].present? ? row[1] : name
  end

  def age_range
    @age_range ||= AgeRange.find_by_normalized_name!(age_range_name)
  end

  def age_range_name
    row[4]
  end

  def priority
    row[3].present? ? row[3].to_i : nil
  end

  def image_name
    row[6]
  end

  def search_query
    row[2]
  end

  def queries
    queries = row[7].present? ? row[7].split(/;\s*/) : []
    queries = [ name ] if queries.empty?
    queries
  end

  def product_type
    @product_type ||= build_product_type
  end

  def save!
    if valid?
      product_type.save!
      queries.each { |query| product_type.add_query(query) }
    end
  end

  private

  def row
    @row
  end

  def build_product_type
    pt = ProductType.find_by_name(name)
    if pt.blank?
      pt = ProductType.new(product_type_attributes,
                           without_protection: true)
    else
      pt.assign_attributes(product_type_attributes,
                           without_protection: true)
    end
    pt
  end

  def product_type_attributes
    {
      category_id: category.id,
      name: name,
      plural_name: plural_name,
      search_query: search_query,
      age_range_id: age_range.id,
      priority: priority,
      image_name: image_name
    }
  end
end
