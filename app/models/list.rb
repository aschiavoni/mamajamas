class List < ActiveRecord::Base
  attr_accessible :title

  belongs_to :user
  has_many :list_product_types

  has_many :product_types, through: :list_product_types do
    def visible
      where("list_product_types.hidden = ?", false)
    end
  end

  has_many :categories, through: :list_product_types, uniq: true do
    def for_list
      order(:name)
    end
  end
  has_many :list_items, dependent: :destroy

  def list_entries(category = nil)
    list_items.by_category(category).order("name ASC") +
      product_types.visible.by_category(category).order("name ASC")
  end

  def add_item(list_item)
    list_items << list_item

    # mark corresponding list product type as hidden
    list_product_type = list_product_types.where(product_type_id: list_item.product_type.id).first

    if list_product_type.present?
      list_product_type.hide!
    end

    list_item
  end
end
