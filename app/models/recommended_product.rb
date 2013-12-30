class RecommendedProduct < ActiveRecord::Base
  belongs_to :product_type
  attr_accessible :image_url, :link, :tag, :vendor, :vendor_id
end
