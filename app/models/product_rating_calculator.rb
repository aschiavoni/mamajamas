class ProductRatingCalculator

  class NoRating; end

  attr_reader :vendor, :vendor_id

  def initialize(vendor_id, vendor)
    @vendor_id = vendor_id
    @vendor = vendor
  end

  def calculate
    ratings = ListItemRatingFinder.find vendor_id, vendor
    return NoRating if ratings.size == 0
    avg = ratings.sum.to_f / ratings.size
    { average: ((avg * 2).round / 2.0), count: ratings.size }
  end
end
