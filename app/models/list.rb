class List < ActiveRecord::Base
  belongs_to :user
  attr_accessible :title

  has_many :list_product_types
  has_many :product_types, through: :list_product_types
  has_many :categories, through: :list_product_types, uniq: true do
    def for_list
      order(:name)
    end
  end
  has_many :list_items, dependent: :destroy

  def list_entries(category = nil)
    list_items.by_category(category).order("name ASC") +
      product_types.by_category(category).order("name ASC")
  end
end
