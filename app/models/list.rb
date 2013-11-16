class List < ActiveRecord::Base
  PRIVACY_PRIVATE       = 0
  PRIVACY_PUBLIC        = 1
  PRIVACY_AUTHENTICATED = 2
  PRIVACY_REGISTRY      = 3

  attr_accessible :title
  attr_accessible :privacy

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

  def private?
    privacy == PRIVACY_PRIVATE
  end

  def public?
    privacy == PRIVACY_PUBLIC
  end

  def authenticated_users_only?
    privacy == PRIVACY_AUTHENTICATED
  end

  def registry?
    privacy == PRIVACY_REGISTRY
  end

  def list_entries(category = nil)
    list_items.
      by_category(category).
      includes(:product_type).
      includes(:category).
      includes(:age_range).
      order(list_entries_sort_order)
  end

  def shared_list_entries(category = nil)
    shared_items = list_items.user_items.
      by_category(category).
      includes(:category).
      includes(:age_range)

    if registry?
      shared_items = shared_items.where(owned: false)
    end

    shared_items.order(list_entries_sort_order)
  end

  def shared_list_categories
    category_ids = shared_list_entries.map(&:category_id).uniq
    categories.
      where(id: category_ids).
      order(:name)
  end

  def share_public!
    set_public(true)
  end

  def unshare_public!
    set_public(false)
  end

  def add_list_item_placeholder(product_type)
    placeholder = ListItem.new do |list_item|
      list_item.placeholder = true
      list_item.product_type_name = product_type.name
      list_item.product_type = product_type
      list_item.category = product_type.category
      list_item.priority = product_type.priority
      list_item.image_url = product_type.image_name
      list_item.age_range = product_type.age_range
      list_item.quantity = product_type.recommended_quantity
    end

    list_items << placeholder

    placeholder
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

  def has_placeholder?(product_type)
    list_items.placeholders.where(product_type_id: product_type.id).any?
  end

  def item_count
    list_items.where(placeholder: false).count
  end

  # these increment methods may not handle concurrency
  # but we don't use them for anything but checking whether
  # the list has been viewed at least once so it doesn't matter
  # for now
  def increment_view_count
    List.increment_counter(:view_count, id)
  end

  def increment_public_view_count
    List.increment_counter(:public_view_count, id)
  end

  def clone_list_item(list_item_id)
    orig = ListItem.find_by_id(list_item_id)
    return nil if orig.blank?

    ListItem.new({
      name: orig.name,
      owned: false,
      link: orig.link,
      priority: orig.priority,
      image_url: orig.image_url,
      product_type_id: orig.product_type_id,
      category_id: orig.category_id,
      placeholder: false,
      product_type_name: orig.product_type_name,
      list_item_image_id: orig.list_item_image_id,
      vendor: orig.vendor,
      vendor_id: orig.vendor_id
    }).tap do |li|
      li.age = orig.age
    end
  end

  def completed?
    completed_at.present?
  end

  def complete!
    update_attributes!({
      completed_at: Time.now.utc
    }, { without_protection: true })
  end

  private

  def default_title
    if user.present?
      "#{(user.first_name || user.username).possessive} List"
    else
      "List"
    end
  end

  def set_public(public)
    privacy = public ? PRIVACY_PUBLIC : PRIVACY_PRIVATE
    self.privacy = privacy
    self.save!
  end

  def list_entries_sort_order
    @li_sort ||=
      "list_items.placeholder ASC, age_ranges.position ASC, categories.name ASC, list_items.product_type_name ASC"
  end

end
