class ProductSearcher
  def self.search(query, limit = 50)
    new.search(query, limit)
  end

  def initialize(product_class = Product)
    @product_class = product_class
  end

  def search(query, limit = nil)
    amazon_fetcher = ProductFetcherFactory.create('amazon')
    products = amazon_fetcher.fetch(query.downcase).map do |item|
      Product.new item
    end.reject { |p| p[:medium_image_url].blank? }

    products = products.take(limit) if limit.present?

    products
  end

  private

  def product_class
    @product_class
  end
end
