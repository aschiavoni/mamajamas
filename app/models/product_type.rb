class ProductType < ActiveRecord::Base
  attr_accessible :category_id, :name, :buy_before, :priority

  belongs_to :category
end
