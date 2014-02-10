class ProductRating < ActiveRecord::Base
  attr_accessible :rating, :rating_count, :vendor, :vendor_id

  def self.suggestable_vendor_ids(product_type)
    join = %Q{
      INNER JOIN list_items ON list_items.vendor_id = product_ratings.vendor_id
    }
    self.joins(join).
      where(["list_items.placeholder = ?", false]).
      where(["list_items.product_type_id = ?", product_type.id]).
      where(["product_ratings.rating_count >= 5"]).
      where(["product_ratings.rating >= 3.0"]).
      select("DISTINCT product_ratings.vendor_id").map(&:vendor_id)
  end
end
