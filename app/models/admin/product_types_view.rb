class Admin::ProductTypesView
  def initialize(category)
    @category = category
  end

  def category_slug
    category.slug
  end

  def categories
    Category.all
  end

  def category
    @category
  end
end
