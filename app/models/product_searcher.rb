class ProductSearcher
  attr_reader :providers, :searchers

  def initialize(options = {})
    @providers = options[:providers] || [ :amazon ]
    @searchers = providers.map do |provider|
      ProductSearcherFactory.create(provider)
    end
  end

  def search(product_type, options = {})
    query(product_type.name, options).map do |attrs|
      build_product(product_type, attrs)
    end
  end

  private

  def build_product(product_type, attrs)
    by_vendor = {
      vendor: attrs[:vendor],
      vendor_id: attrs[:vendor_id]
    }
    product = Product.unscoped.where(by_vendor).first_or_initialize(by_vendor)
    product.update_attributes(attrs.merge(product_type_id: product_type.id))
    product
  end

  def query(query, options = {})
    searchers.map do |finder|
      finder.search(query, options)
    end.flatten
  end
end
