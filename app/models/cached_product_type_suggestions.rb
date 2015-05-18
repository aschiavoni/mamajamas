class CachedProductTypeSuggestions
  def self.find(product_type)
    cache_id = "product:suggestions:#{product_type.name.parameterize}"
    Rails.cache.fetch(cache_id, expire_in: 24.hours) do
      ProductTypeSuggestions.find(product_type)
    end
  end
end
