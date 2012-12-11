class ProductTypeQuery < ActiveRecord::Base
  belongs_to :product_type
  attr_accessible :query

  validates :product_type_id, :query, presence: true
end
