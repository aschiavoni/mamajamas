class ProductRating < ActiveRecord::Base
  attr_accessible :rating, :rating_count, :vendor, :vendor_id
end
