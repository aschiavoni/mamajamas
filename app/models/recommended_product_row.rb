class RecommendedProductRow
  def initialize(row)
    @row = row
  end

  def name
    row[2]
  end

  def product_type
    @product_type ||= ProductType.find_by_name(name)
  end

  def eco_name
    row[12]
  end

  def eco_link
    row[13]
  end

  def upscale_name
    row[14]
  end

  def upscale_link
    row[15]
  end

  def cost_name
    row[16]
  end

  def cost_link
    row[17]
  end

  def extra_name
    row[18]
  end

  def extra_link
    row[19]
  end

  def twins_name
    row[20]
  end

  def twins_link
    row[21]
  end

  def update_hash
    h = {}
    [ :eco, :upscale, :cost, :extra, :twins ].each do |tag|
      th = build_tag_hash(tag)
      h[tag] = th unless th.blank?
    end
    h
  end

  def save!
    RecommendedProductService.create_or_update!(update_hash)
  end

  private

  def row
    @row
  end

  def build_tag_hash(tag)
    link = send("#{tag}_link")
    name = send("#{tag}_name") || ""
    if link.present? && product_type.present?
      {
        tag: tag.to_s,
        product_type_id: product_type.id,
        link: link,
        name: name.strip
      }
    else
      # if product_type.blank?
      #   puts "Could not find product type for #{name}."
      # end
      nil
    end
  end
end
