class ProductLookup
  def self.lookup(ids)
    new.lookup(ids)
  end

  def initialize(product_class = Product)
    @product_class = product_class
  end

  def lookup(ids)
    ids = [ ids ].flatten
    fetcher = ProductFetcherFactory.create('amazon')
    results = fetcher.lookup(ids)
    results.map { |r| product_class.new r }
  end

  private

  def product_class
    @product_class
  end
end
