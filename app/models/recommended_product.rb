class RecommendedProduct < ActiveRecord::Base
  belongs_to :product_type
  attr_accessible :product_type_id, :name, :image_url
  attr_accessible :link, :tag, :vendor, :vendor_id
end
