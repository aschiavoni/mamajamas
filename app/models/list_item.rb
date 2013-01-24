class ListItem < ActiveRecord::Base
  include Categorizable
  include WhenToBuyAccessors

  belongs_to :list
  belongs_to :product_type
  belongs_to :when_to_buy_suggestion

  attr_accessible :link, :name, :notes, :owned
  attr_accessible :priority, :rating, :when_to_buy, :image_url
  attr_accessible :category_id, :product_type_id, :product_type_name
  attr_accessible :placeholder

  validates :name, :link, presence: true, unless: :placeholder?
end
