class ListView
  include Rails.application.routes.url_helpers

  attr_reader :list
  attr_reader :category_slug
  attr_reader :current_user

  def initialize(list, category_slug = nil, current_user = nil)
    @list = list
    @category_slug = category_slug
    @current_user = current_user
  end

  def categories
    @categories ||= list.categories.for_list
  end

  def list_entries
    @list_entries ||= list.list_entries(category)
  end

  def recommended_items?
    list_entries.recommended.any?
  end

  def list_entries_by_priority(priority)
    list_items_by_priority[priority]
  end

  def category
    @category ||= find_category
  end

  def category_name
    @category.present? ? @category.name : "All"
  end

  def owner
    @owner ||= decorated_owner
  end

  def all_category?
    @category_slug == 'all'
  end

  def product_types
    @product_types ||= product_types_hash
  end

  private

  def find_category
    if @category_slug.present?
      @category = categories.by_slug(@category_slug).first
    else
      @category = categories.order(:name).first
    end
    @category
  end

  def decorated_owner
    owner = list.user
    owner.class.send(:include, UserDecorator)
    owner
  end

  def list_items_by_priority
    @list_items_by_priority ||= group_by_priority
  end

  def group_by_priority
    by_priority = Hash.new {|h, k| h[k] = []}
    list_entries.each do |list_entry|
      by_priority[list_entry.priority] << list_entry
    end
    by_priority
  end

  def product_types_hash
    if category.present?
      category.product_types.order(:name).map { |pt|
        { name: pt.name, id: pt.id }
      }
    else
      []
    end
  end
end
