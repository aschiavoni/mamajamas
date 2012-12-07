class ProductSearcher
  include ActionView::Helpers::TextHelper

  attr_reader :providers, :searchers

  def initialize(options = {})
    @providers = options[:providers] || [ :amazon ]
    @searchers = providers.map do |provider|
      ProductSearcherFactory.create(provider)
    end
  end

  def search(product_type, options = { pages: 5 })
    query(product_type.name, options).map do |attrs|
      build_product(product_type, attrs)
    end
  end

  protected

  def build_product(product_type, attrs)
    attrs.symbolize_keys!
    attrs[:name] = sanitize_name(attrs[:name])

    vendor_id = {
      vendor: attrs[:vendor],
      vendor_id: attrs[:vendor_id]
    }
    product = Product.where(vendor_id).first_or_initialize(vendor_id)
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

  private

  def sanitize_name(name)
    name = HTMLEntities.new.decode(name)
    truncate(name, length: 250, omission: "", separator: " ")
  end
end
