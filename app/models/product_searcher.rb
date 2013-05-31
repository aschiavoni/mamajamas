class ProductSearcher
  def self.search(query, search_index = nil, limit = 10)
    new.search(query, search_index, limit)
  end

  def initialize(product_class = Product)
    @product_class = product_class
  end

  def search(query, search_index = nil, limit = 10)
    fetcher = ProductFetcherFactory.create('amazon')

    fetch_options = {
      search_index: search_index,
      pages: (limit.nil? ? 1 : (limit / 10.0).ceil)
    }

    results = fetcher.cached_fetch(query.downcase, fetch_options).reject do |p|
      p[:medium_image_url].blank? || p[:price].blank?
    end
    results = results.take(limit) if limit.present?

    results.map { |r| product_class.new r }
  end

  private

  def product_class
    @product_class
  end
end
