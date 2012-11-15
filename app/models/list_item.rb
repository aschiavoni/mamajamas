class ListItem < ActiveRecord::Base
  belongs_to :list
  belongs_to :product_type
  belongs_to :category

  attr_accessible :link, :name, :notes, :owned, :priority, :rating, :when_to_buy, :image_url
end
