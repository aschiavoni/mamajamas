class ProductRatingUpdater
  def initialize(calculator = ProductRatingCalculator)
    @calculator = calculator
  end

  def update
    ListItem.unique_products.each do |product_data|
      vendor_id, vendor = product_data
      product_rating = ProductRating.where(vendor: vendor, vendor_id: vendor_id).first
      rating = calculator.new(vendor_id, vendor).calculate
      if rating == calculator::NoRating
        product_rating.destroy if product_rating.present?
      else
        if product_rating.present?
          product_rating.update_attributes!(rating: rating)
        else
          ProductRating.create(vendor: vendor, vendor_id: vendor_id, rating: rating)
        end
      end
    end
  end

  private

  def calculator
    @calculator
  end
end
