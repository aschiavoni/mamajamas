class ProductTypeSuggestions
  def self.find(product_type)
    new.find(product_type)
  end

  def initialize(searcher = ProductSearcher)
    @searcher = searcher
  end

  def find(product_type)
    suggestions = searcher.search(product_type.name, 'All', 8).map do |product|
      product.attributes
    end
    { id: product_type.id, suggestions: suggestions }
  end

  private

  def searcher
    @searcher
  end
end
