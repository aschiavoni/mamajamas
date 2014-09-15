class Product < ActiveRecord::Base
  include PgSearch

  attr_accessible :name
  attr_accessible :rating
  attr_accessible :rating_count
  attr_accessible :url
  attr_accessible :image_url
  attr_accessible :medium_image_url
  attr_accessible :large_image_url
  attr_accessible :vendor
  attr_accessible :vendor_id
  attr_accessible :vendor_name
  attr_accessible :sales_rank
  attr_accessible :brand
  attr_accessible :manufacturer
  attr_accessible :model
  attr_accessible :department
  attr_accessible :categories
  attr_accessible :price
  attr_accessible :mamajamas_rating
  attr_accessible :mamajamas_rating_count
  attr_accessible :vendor_product_type_name
  attr_accessible :product_type_name
  attr_accessible :product_type_id
  attr_accessible :description
  attr_accessible :short_description

  belongs_to :product_type

  validates :name, :vendor, :vendor_name, :url, :image_url, presence: true
  validates :vendor_id, presence: true, uniqueness: { scope: :vendor }

  pg_search_scope(:search_by_name,
                  against: :name,
                  using: { tsearch: { prefix: true } })
end
