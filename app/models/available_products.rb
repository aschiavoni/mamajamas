class AvailableProducts
  def initialize(product_class = Product)
    @product_class = product_class
  end

  def find(product_type = nil, filter = nil, limit = nil)
    if product_type.present?
      products = find_active_products(product_type)
    else
      products = product_class.active
    end

    products = filter_by(products, filter) if filter.present?
    products = limit_by(products, limit) if limit.present?
    products
  end

  private

  def find_active_products(product_type)
    products = product_type.products.active
    if products.size == 0
      products = product_class.active
    end
    products
  end

  def filter_by(products, filter)
    if filter.present?
      products = products.where("lower(name) LIKE ?", "%#{filter.downcase}%")
    end
    products
  end

  def limit_by(products, limit)
    products.limit(limit)
  end

  def product_class
    @product_class
  end
end
