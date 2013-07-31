class Admin::ProductTypesView
  def initialize(category)
    if category.present?
      @category = category
    else
      @category = categories.first
    end
  end

  def category_slug
    category.slug
  end

  def categories
    @categories ||= Category.scoped.order(:name)
  end

  def category
    @category
  end

  def product_types
    category.product_types.order(:name)
  end
end
