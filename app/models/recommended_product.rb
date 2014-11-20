class RecommendedProduct < ActiveRecord::Base
  belongs_to :product_type
  attr_accessible :product_type_id, :name, :image_url
  attr_accessible :link, :tag, :vendor, :vendor_id, :price

  def self.suggestable_vendor_ids(product_type)
    self.where(product_type_id: product_type.id).pluck(:vendor_id)
  end
end
