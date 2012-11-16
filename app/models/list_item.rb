class ListItem < ActiveRecord::Base
  belongs_to :list
  belongs_to :product_type
  belongs_to :category

  attr_accessible :link, :name, :notes, :owned, :priority, :rating, :when_to_buy, :image_url
  attr_accessible :list_id, :product_type_id, :category_id

  validates :name, :link, presence: true
end
