class Category < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: [ :slugged ]

  attr_accessible :name

  has_many :product_types, dependent: :destroy
end
