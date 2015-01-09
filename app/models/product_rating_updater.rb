class ProductRatingUpdater
  def initialize(calculator = ProductRatingCalculator)
    @calc = calculator
  end

  def update
    ListItem.unique_products.each do |product_data|
      rating = calculate(*product_data)
      rating.present? ? rating.save! : remove_rating(*product_data)
    end

    ProductRating.for_recommended_products.each do |rating|
      rp = RecommendedProduct.find_by(vendor: rating.vendor,
                                      vendor_id: rating.vendor_id)

      if rp.present?
        rp.rating = rating.rating.round
        rp.save!
      end
    end
  end

  private

  def calculate(vendor_id, vendor)
    rating = calc.new(vendor_id, vendor).calculate
    return nil if rating == calc::NoRating
    build_rating(vendor_id, vendor, rating)
  end

  def build_rating(vendor_id, vendor, rating)
    vattrs = { vendor_id: vendor_id, vendor: vendor }
    pr = ProductRating.where(vattrs).first || ProductRating.new(vattrs)
    pr.rating = rating[:average]
    pr.rating_count = rating[:count]
    pr
  end

  def remove_rating(vendor_id, vendor)
    vattrs = { vendor_id: vendor_id, vendor: vendor }
    product_rating = ProductRating.where(vattrs).first
    product_rating.destroy if product_rating.present?
  end

  def calc
    @calc
  end
end
