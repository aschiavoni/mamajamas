module ProductTypeDecorator
  extend Memoist

  def category_name
    category.name
  end
end
