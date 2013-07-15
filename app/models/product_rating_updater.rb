class ProductRatingUpdater
  def initialize(calculator = ProductRatingCalculator)
    @calc = calculator
  end

  def update
    ListItem.unique_products.each do |product_data|
      rating = calculate(*product_data)
      rating.present? ? rating.save! : remove_rating(*product_data)
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
    pr.rating = rating
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
