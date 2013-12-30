class RecommendedProduct < ActiveRecord::Base
  belongs_to :product_type
  attr_accessible :name, :image_url, :link, :tag, :vendor, :vendor_id
end
