class ProductType < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: [ :slugged ]

  attr_accessible :category_id, :name, :buy_before, :priority

  belongs_to :category

  class << self
    def by_category(category)
      category.blank? ? scoped : where(category_id: category.id)
    end
  end
end
