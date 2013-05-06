class CachedProductFetcher < ProductFetcher
  def initialize(cache_hours, options = {})
    @cache_hours = cache_hours || 24
    super options
  end

  protected

  def query(query, options)
    cache_id = "product:fetcher:#{query.parameterize}:#{options_sig(options)}"
    json = Rails.cache.fetch(cache_id, expire_in: cache_hours) do
      super(query, options).to_json
    end

    JSON.parse(json)
  end

  private

  def options_sig(options)
    Digest::MD5.hexdigest(options.inspect)
  end

  private

  def cache_hours
    @cache_hours.hours
  end
end
