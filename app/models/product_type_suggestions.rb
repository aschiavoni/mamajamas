class ProductTypeSuggestions
  def self.find(product_type)
    new.find(product_type)
  end

  def initialize(searcher = ProductSearcher)
    @searcher = searcher
  end

  def find(product_type)
    suggestions = recommended_product_lookup(product_type)
    suggestions.concat popular_product_lookup(product_type)
    suggestions.concat search_results(product_type)

    suggestions = suggestions.uniq { |s| s.vendor_id }
    suggestions = suggestions.reject do |s|
      s.mamajamas_rating.present? && s.mamajamas_rating_count.present? &&
        s.mamajamas_rating < 3.0 && s.mamajamas_rating_count > 5
    end
    { id: product_type.id, suggestions: suggestions.map(&:attributes) }
  end

  private

  def recommended_product_lookup(product_type)
    ProductLookup.lookup(RecommendedProduct.
                         suggestable_vendor_ids(product_type))
  end

  def popular_product_lookup(product_type)
    ProductLookup.lookup(ProductRating.suggestable_vendor_ids(product_type))
  end

  def search_results(product_type)
    ProductTypeSearcher.search(product_type)
  end
end
