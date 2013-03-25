class ListItem < ActiveRecord::Base
  include Categorizable
  include AgeRangeAccessors

  belongs_to :list
  belongs_to :product_type
  belongs_to :age_range
  has_one :list_item_image

  attr_accessible :link, :name, :notes, :owned
  attr_accessible :priority, :rating, :age, :image_url
  attr_accessible :category_id, :product_type_id, :product_type_name
  attr_accessible :placeholder, :list_item_image_id

  validates :name, :link, presence: true, unless: :placeholder?
end
