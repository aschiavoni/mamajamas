class ListItem < ActiveRecord::Base
  include Categorizable
  include WhenToBuyAccessors

  belongs_to :list
  belongs_to :product_type
  belongs_to :when_to_buy_suggestion

  attr_accessible :link, :name, :notes, :owned, :priority, :rating, :when_to_buy, :image_url
  attr_accessible :list_id, :product_type_id

  validates :name, :link, presence: true
end
