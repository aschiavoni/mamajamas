class ListItem < ActiveRecord::Base
  include Categorizable
  include AgeRangeAccessors

  belongs_to :list
  belongs_to :product_type
  belongs_to :age_range

  attr_accessible :link, :name, :notes, :owned
  attr_accessible :priority, :rating, :age, :image_url
  attr_accessible :category_id, :product_type_id, :product_type_name
  attr_accessible :placeholder

  validates :name, :link, presence: true, unless: :placeholder?
end
