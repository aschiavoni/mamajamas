class ProductSearcher
  attr_reader :providers, :finders

  def initialize(options = {})
    @providers = options[:providers] || [ :amazon ]
    @finders = initialize_finders
    initialize_finders
  end

  def search(query, options = {})
    finders.map do |finder|
      finder.search(query)
    end.flatten
  end

  private

  def initialize_finders
    providers.map do |provider|
      ProductSearcherFactory.create(provider)
    end
  end
end
