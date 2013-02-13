class PublicListView
  attr_reader :list
  attr_reader :category

  def initialize(list, category_slug = nil)
    @list = list
    if category_slug.present?
      @category = categories.by_slug(category_slug).first
    else
      @category = categories.first
    end
  end

  def categories
    @categories ||= list.categories.for_list
  end

  def list_entries
    @list_entries ||= list.public_list_entries(category)
  end
end
