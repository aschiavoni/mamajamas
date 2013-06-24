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
      includes(:category).
      includes(:age_range).
      order("list_items.placeholder ASC, age_ranges.position ASC, list_items.priority ASC")
  end

  def public_list_entries(category = nil)
    list_items.shared_items.
      by_category(category).
      includes(:age_range).
      order("list_items.placeholder ASC, age_ranges.position ASC, list_items.priority ASC")
  end

  def public_list_categories
    categories.
      where(id: list_items.shared_items.select('DISTINCT(category_id)')).
      order(:name)
  end

  def public_preview_list_entries(category = nil)
    list_items.user_items.
      by_category(category).
      includes(:age_range).
      order("list_items.placeholder ASC, age_ranges.position ASC, list_items.priority ASC")
  end

  def public_preview_list_categories
    categories.
      where(id: list_items.user_items.select('DISTINCT(category_id)')).
      order(:name)
  end

  def share_public!
    set_public(true)
    share_all_list_items!
  end

  def unshare_public!
    set_public(false)
    unshare_all_list_items!
  end

  def share_all_list_items!
    list_items.user_items.update_all(shared: true)
  end

  def unshare_all_list_items!
    list_items.user_items.update_all(shared: false)
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

  def has_items?
    list_items.where(placeholder: false).any?
  end

  def item_count
    list_items.where(placeholder: false).count
  end

  # these increment methods may no handle concurrency
  # but we don't use them for anything but checking whether
  # the list has been viewed at least once so it doesn't matter
  # for now
  # http://apidock.com/rails/ActiveRecord/Base/increment!
  def increment_view_count
    increment!(:view_count)
  end

  def increment_public_view_count
    increment!(:public_view_count)
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
