class ProductSearcher
  def self.search(query, limit = 50)
    new.search(query, limit)
  end

  def initialize(product_class = Product)
    @product_class = product_class
  end

  def search(query, limit = nil)
    products = product_class.text_search(query)
    products = products.limit(limit) if limit.present?
    products
  end

  private

  def product_class
    @product_class
  end
end
