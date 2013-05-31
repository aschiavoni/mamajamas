class ProductTypeSuggestions
  def self.find(product_type)
    new.find(product_type)
  end

  def initialize(searcher = ProductSearcher)
    @searcher = searcher
  end

  def find(product_type)
    searcher.search(product_type.name, 'All', 8)
  end

  private

  def searcher
    @searcher
  end
end
