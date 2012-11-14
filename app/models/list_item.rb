class ListItem < ActiveRecord::Base
  belongs_to :list
  attr_accessible :link, :name, :notes, :owned, :priority, :rating, :when_to_buy, :image_url
end
