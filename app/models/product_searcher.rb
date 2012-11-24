class ProductSearcher
  include ActionView::Helpers::TextHelper

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

  protected

  def build_product(product_type, attrs)
    attrs.symbolize_keys!

    vendor_id = {
      vendor: attrs[:vendor],
      vendor_id: attrs[:vendor_id]
    }
    product = Product.unscoped.where(vendor_id).first_or_initialize(vendor_id)

    attrs[:name] = truncate(attrs[:name], length: 250, omission: "", separator: " ")
    product.assign_attributes(attrs.merge(product_type_id: product_type.id))

    if product.changed?
      product.save!
    else
      # refresh updated_at regardless of whether it changed
      product.touch
    end

    product
  end

  def query(query, options = {})
    searchers.map do |finder|
      finder.search(query, options)
    end.flatten
  end
end
