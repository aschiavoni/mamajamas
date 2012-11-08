class Category < ActiveRecord::Base
  attr_accessible :name

  has_many :product_types, dependent: :destroy
end
