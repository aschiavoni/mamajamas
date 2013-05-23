class ProductSearcher
  def self.search(query, limit = 50)
    new.search(query, limit)
  end

  def initialize(product_class = Product)
    @product_class = product_class
  end

  def search(query, limit = nil)
    amazon_fetcher = ProductFetcherFactory.create('amazon')

    results = amazon_fetcher.fetch(query.downcase).reject do |p|
      p[:medium_image_url].blank? || p[:price].blank?
    end
    results = results.take(limit) if limit.present?

    results.map { |r| Product.new r }
  end

  private

  def product_class
    @product_class
  end
end
