class ProductFetcher
  include ActionView::Helpers::TextHelper

  attr_reader :providers, :fetchers

  def initialize(options = {})
    @providers = options[:providers] || [ :amazon ]
    @fetchers = providers.map do |provider|
      ProductFetcherFactory.create(provider)
    end
  end

  def fetch(product_type, options = { pages: 1 })
    product_type.queries.map do |query|
      query(query.query, options).map do |attrs|
        build_product(product_type, attrs)
      end
    end.flatten
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
    product.assign_attributes(attrs)

    if product.changed?
      product.save!
    else
      # refresh updated_at regardless of whether it changed
      product.touch
    end

    unless product.product_types.include?(product_type)
      product.product_types << product_type
    end

    product
  end

  def query(query, options = {})
    fetchers.map do |finder|
      finder.fetch(query, options)
    end.flatten
  end

  private

  def sanitize_name(name)
    name = HTMLEntities.new.decode(name)
    truncate(name, length: 250, omission: "", separator: " ")
  end
end
