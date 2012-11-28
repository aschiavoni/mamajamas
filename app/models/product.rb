class Product < ActiveRecord::Base
  belongs_to :product_type
  attr_accessible :name, :rating, :url, :image_url, :vendor, :vendor_id, :product_type_id

  validates :name, :vendor, :url, :product_type_id, presence: true
  validates :vendor_id, presence: true, uniqueness: { scope: :vendor }

  default_scope lambda { where("updated_at > ?", (Time.zone.now - 24.hours)) }
  scope :expired, lambda { where("updated_at < ?", (Time.zone.now - 24.hours)) }
end
