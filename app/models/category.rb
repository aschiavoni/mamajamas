class Category < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: [ :slugged, :finders ]

  attr_accessible :name

  has_many :product_types, dependent: :destroy

  def self.by_slug(slug)
    where(slug: slug)
  end
end
