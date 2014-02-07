class ProductTypeSearcher
  def self.search(product_type)
    new.search(product_type)
  end

  def initialize(searcher = ProductSearcher)
    @searcher = searcher
  end

  def search(product_type)
    search_index = search_index(product_type)
    search_query = search_query(product_type)
    searcher.search(search_query, search_index, 10)
  end

  private

  def searcher
    @searcher
  end

  def search_index(product_type)
    product_type.search_index.present? ? product_type.search_index : 'All'
  end

  def search_query(product_type)
    if product_type.search_query.present?
      product_type.search_query
    else
      product_type.name
    end
  end
end
