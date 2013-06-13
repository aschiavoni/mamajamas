class ListView
  include Rails.application.routes.url_helpers

  attr_reader :list
  attr_reader :category_slug

  def initialize(list, category_slug = nil)
    @list = list
    @category_slug = category_slug
  end

  def categories
    @categories ||= list.categories.for_list
  end

  def list_entries
    @list_entries ||= list.list_entries(category)
  end

  def category
    @category ||= find_category
  end

  def owner
    list.user
  end

  def default_category?
    @category_slug.blank?
  end

  private

  def find_category
    if @category_slug.present?
      @category = categories.by_slug(@category_slug).first
    end
    @category
  end
end
