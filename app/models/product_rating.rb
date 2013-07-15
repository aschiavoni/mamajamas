class ProductRating < ActiveRecord::Base
  attr_accessible :rating, :vendor, :vendor_id
end
