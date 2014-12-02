class List < ActiveRecord::Base
  PRIVACY_PRIVATE       = 0
  PRIVACY_PUBLIC        = 1
  PRIVACY_REGISTERED    = 2
  PRIVACY_WANT_ONLY      = 3

  attr_accessible :title
  attr_accessible :notes
  attr_accessible :privacy
  attr_accessible :registry
  attr_accessible :saved
  attr_accessible :featured, as: :admin
  attr_accessible :expert, as: :admin

  belongs_to :user
  has_many :categories, -> { uniq }, through: :list_items do
    def for_list
      order(:name)
    end
  end
  has_many :list_items, dependent: :destroy

  validates :title, length: { minimum: 3, maximum: 45 }

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

  def registered_users_only?
    privacy == PRIVACY_REGISTERED
  end

  def want_only?
    privacy == PRIVACY_WANT_ONLY
  end

  def list_entries(category = nil)
    list_items.
      by_category(category).
      includes(:product_type).
      includes(:category).
      includes(:age_range).
      references(:categories).
      references(:age_ranges).
      references(:list_items).
      order(list_entries_sort_order)
  end

  def shared_list_entries(category = nil, ignore_privacy = false)
    shared_items = list_items.user_items.
      by_category(category).
      includes(:product_type).
      includes(:category).
      includes(:age_range).
      references(:categories).
      references(:age_ranges).
      references(:list_items)

    if !ignore_privacy && want_only?
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

  def add_list_item_placeholder(product_type)
    placeholder = ListItem.new do |list_item|
      list_item.placeholder = true
      list_item.product_type_name = product_type.name
      list_item.product_type = product_type
      list_item.category = product_type.category
      list_item.priority = product_type.priority
      list_item.image_url = product_type.image_name
      list_item.age_range = product_type.age_range
      list_item.desired_quantity = product_type.recommended_quantity
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
    product_types = ProductType.global_active.order("name ASC")
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
      if user.guest?
        "Your baby registry"
      else
        if user.partner_full_name.present?
          "#{(user.first_name || user.username)} & #{user.partner_full_name.split(" ").first.possessive} baby registry".html_safe
        else
          "#{(user.first_name || user.username).possessive} baby registry"
        end
      end
    else
      "Baby registry"
    end
  end

  def list_entries_sort_order
    @li_sort ||=
      "list_items.placeholder ASC, age_ranges.position ASC, categories.name ASC, list_items.product_type_name ASC"
  end

end
