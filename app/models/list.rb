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

  def add_list_item(list_item)
    list_items << list_item

    # mark corresponding list product type as hidden
    list_product_type = list_product_types.where(product_type_id: list_item.product_type.id).first

    if list_product_type.present?
      list_product_type.hide!
    end

    list_item
  end

  def add_product_type(product_type)
    existing_product_type = ProductType.global.where(name: product_type.name).first
    if existing_product_type.blank?
      user.product_types << product_type
    else
      product_type = existing_product_type
    end

    existing_list_product_type = list_product_types.where(product_type_id: product_type.id).first
    if existing_list_product_type.present?
      existing_list_product_type.unhide! if existing_list_product_type.hidden?
    else
      add_list_product_type(product_type)
    end

    product_type
  end

  def available_product_types
    hidden_list_product_types =
      product_types.where("list_product_types.hidden = ?", true)
    (ProductType.global + user.product_types) - product_types + hidden_list_product_types
  end

  private

  def add_list_product_type(product_type)
    list_product_type = ListProductType.new({
      product_type: product_type,
      category: product_type.category
    })
    list_product_type.list_id = self.id
    list_product_type.save!
  end
end
