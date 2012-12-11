class Product < ActiveRecord::Base
  has_and_belongs_to_many :product_types
  attr_accessible :name, :rating, :url, :image_url, :vendor, :vendor_id

  validates :name, :vendor, :url, presence: true
  validates :vendor_id, presence: true, uniqueness: { scope: :vendor }

  scope :active, lambda { where("updated_at > ?", (Time.zone.now - 24.hours)) }
  scope :expired, lambda { where("updated_at < ?", (Time.zone.now - 24.hours)) }
end
