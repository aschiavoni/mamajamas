class List < ActiveRecord::Base
  attr_accessible :title

  belongs_to :user
  has_many :list_product_types

  has_many :product_types, through: :list_product_types do
    def visible
      where("list_product_types.hidden = ?", false)
    end

    def in_category(category)
      if category.present?
        where("list_product_types.category_id = ?", category.id)
      else
        scoped
      end
    end
  end

  has_many :categories, through: :list_items, uniq: true do
    def for_list
      order(:name)
    end
  end
  has_many :list_items, dependent: :destroy

  def title
    read_attribute(:title) || default_title
  end

  def title=(new_title)
    new_title = nil if new_title.blank? # don't allow "" as a title
    write_attribute(:title, new_title) unless new_title == default_title
  end

  def list_entries(category = nil)
    list_items.by_category(category).order("placeholder, name ASC")
  end

  def add_list_item_placeholder(product_type)
    list_item = ListItem.new.tap do |list_item|
      list_item.placeholder = true
      list_item.name = product_type.name
      list_item.product_type = product_type
      list_item.category = product_type.category
      list_item.priority = product_type.priority
      # TODO: don't hardcode image path
      list_item.image_url = "/assets/products/icons/#{product_type.image_name}"
      list_item.when_to_buy_suggestion = product_type.when_to_buy_suggestion
    end

    list_items << list_item

    list_item
  end

  def add_list_item(list_item)
    list_item.placeholder = false
    list_items << list_item
    list_item
  end

  def available_product_types
    hidden_list_product_types =
      product_types.where("list_product_types.hidden = ?", true)
    (ProductType.global + user.product_types) - product_types + hidden_list_product_types
  end

  private

  def default_title
    user.present? ? "#{user.username.possessive} List" : "List"
  end

  def add_list_product_type(product_type)
    list_product_type = ListProductType.new({
      product_type: product_type,
      category: product_type.category
    })
    list_product_type.list_id = self.id
    list_product_type.save!
  end
end
