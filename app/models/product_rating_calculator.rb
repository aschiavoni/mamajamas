class ProductRatingCalculator

  class NoRating; end

  attr_reader :vendor, :vendor_id

  def initialize(vendor_id, vendor)
    @vendor_id = vendor_id
    @vendor = vendor
  end

  def calculate
    ratings = ProductRatingFinder.find vendor_id, vendor
    return NoRating if ratings.size == 0
    avg = ratings.sum.to_f / ratings.size
    (avg * 2).round / 2.0
  end
end
