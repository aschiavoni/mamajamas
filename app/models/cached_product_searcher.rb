class CachedProductSearcher < ProductSearcher
  protected

  def query(query, options)
    cache_id = "product:searcher:#{query.parameterize}:#{options_sig(options)}"
    json = Rails.cache.fetch(cache_id, expire_in: 1.minute) do
      super(query, options).to_json
    end

    JSON.parse(json)
  end

  private

  def options_sig(options)
    Digest::MD5.hexdigest(options.inspect)
  end
end
