# explicity depend on Product to fix undefined class/module errors in dev
# http://aaronvb.com/articles/37-rails-caching-and-undefined-class-module
require_dependency 'product'

class ListView
  attr_reader :list
  attr_reader :category

  def initialize(list, category_slug = nil)
    @list = list
    if category_slug.present?
      @default_category = false
      @category = categories.by_slug(category_slug).first
    else
      @default_category = true
      @category = nil
    end
  end

  def categories
    @categories ||= list.categories.for_list
  end

  def list_entries
    @list_entries ||= list.list_entries(category)
  end

  def suggestions
    suggestions = list_entries.map do |list_entry|
      product_type = list_entry.product_type
      if product_type.present?
        [ product_type.id, CachedProductTypeSuggestions.find(product_type) ]
      end
    end.reject { |suggestion| suggestion.blank? }
    Hash[suggestions]
  end

  def owner
    list.user
  end

  def default_category?
    @default_category == true
  end
end
