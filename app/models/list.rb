class List < ActiveRecord::Base
  attr_accessible :title

  belongs_to :user
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
    list_items.
      by_category(category).
      includes(:product_type).
      order("placeholder ASC, product_type_name ASC")
  end

  def public_list_entries(category = nil)
    list_items.
      where(placeholder: false).
      by_category(category).
      order("placeholder ASC, product_type_name ASC")
  end

  def make_public!
    set_public(true)
  end

  def make_nonpublic!
    set_public(false)
  end

  def add_list_item_placeholder(product_type)
    list_item = ListItem.new do |list_item|
      list_item.placeholder = true
      list_item.product_type_name = product_type.name
      list_item.product_type = product_type
      list_item.category = product_type.category
      list_item.priority = product_type.priority
      # TODO: don't hardcode image path
      list_item.image_url = "/assets/products/icons/#{product_type.image_name}"
      list_item.age_range = product_type.age_range
    end

    list_items << list_item

    list_item
  end

  def add_list_item(list_item, placeholder = false)
    list_item.placeholder = placeholder
    list_items << list_item
    list_item
  end

  def available_product_types(filter = nil, limit = nil)
    product_types = ProductType.global.order("name ASC")
    if filter.present?
      product_types = product_types.where("lower(name) LIKE ?", "%#{filter.downcase}%")
    end
    product_types = product_types.limit(limit) if limit.present?
    product_types
  end

  private

  def default_title
    user.present? ? "#{user.username.possessive} List" : "List"
  end

  def set_public(public)
    self.public = public
    self.save!
  end

end
