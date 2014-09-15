class AmazonProductFetcher
  include ProductFetcherLogging

  class FailedSearch
    attr_reader :exception

    def initialize(exception)
      @exception = exception
    end

    def items
      []
    end
  end

  VENDOR = "amazon"
  VENDOR_NAME = "Amazon.com"

  def initialize(logger = ProductFetcherLogger, options = {})
    @logger = logger
    Amazon::Ecs.options = {
      associate_tag: options["associate_tag"],
      AWS_access_key_id: options["access_key_id"],
      AWS_secret_key: options["secret_key"]
    }
  end

  def cached_fetch(query, options = {})
    cache_hours = options[:cache_hours] || 23
    cache_id = "product:fetcher:#{query.parameterize}:#{options_sig(options)}"
    json = Rails.cache.fetch(cache_id, expire_in: cache_hours) do
      fetch(query, options).to_json
    end

    JSON.parse(json).map(&:symbolize_keys)
  end

  def lookup(ids, options = {})
    default_options = {}
    options = default_options.merge(options)
    ids = [ ids ].flatten
    results = []

    ids.each_slice(10) do |slice|
      # simple throttle so we don't abuse the api
      sleep sleep_time
      query = slice.join(",")
      info "Looking up #{query}..."
      res = perform_lookup(query)
      results << map_items(res.items)
    end

    results.flatten
  end

  def fetch(query, options = {})
    default_options = { pages: 1, search_index: 'All' }
    options = default_options.merge(options)
    results = []

    options[:pages].times do |i|
      page = i + 1
      # simple throttle so we don't abuse the api
      sleep sleep_time

      info "Searching for #{query}, page #{page}..."
      res = perform_fetch(page, query, options[:search_index])

      results << map_items(res.items)
    end

    results.flatten
  end

  private

  def sleep_time
    1.1
  end

  # TODO: get the price from the offer summary if there is no list price
  def get_price(item)
    price = nil
    list_price = item.get_element('ItemAttributes').get_element('ListPrice')
    price = list_price.get('FormattedPrice') if list_price.present?
    price
  end

  def get_offer_price(item)
    price = get_price(item)
    first_offer = get_offer(item)
    if first_offer.present?
      offer_price = first_offer.get_element("Price")
      price = offer_price.get("FormattedPrice") if offer_price.present?
    end
    price
  end

  def get_offer(item)
    offers = item.get_element("Offers")
    return offers.get_element("Offer") if offers.present?
    nil
  end

  def perform_fetch(page, query, search_index)
    tries ||= 2
    search_index = 'All' if search_index.blank?
    Amazon::Ecs.item_search(query, {
      :response_group => 'Large',
      :search_index => search_index,
      :item_page => page
    })
  rescue Exception => e
    if (tries -= 1) > 0
      info "Retrying search for #{query}, page #{page}..."
      sleep sleep_time
      retry
    else
      error "Error searching for #{query}, page #{page}: #{e}"
      FailedSearch.new e
    end
  end

  def perform_lookup(query)
    tries ||= 2
    Amazon::Ecs.item_lookup(query, {
      :response_group => 'Large'
    })
  rescue Exception => e
    if (tries -= 1) > 0
      info "Retrying lookup for #{query}..."
      sleep sleep_time
      retry
    else
      error "Error looking up #{query}: #{e}"
      FailedSearch.new e
    end
  end

  def options_sig(options)
    Digest::MD5.hexdigest(options.inspect)
  end

  def get_mamajamas_rating(vendor_id, vendor)
    conditions = { vendor_id: vendor_id, vendor: vendor }
    product_rating = ProductRating.where(conditions).first
    product_rating.present? ? product_rating : nil
  end

  def map_items(items)
    items.each_with_index.map do |item, idx|
      vendor_id = item.get('ASIN')
      mamajamas_rating = get_mamajamas_rating(vendor_id, VENDOR)
      item_attributes = item.get_element('ItemAttributes')
      browse_nodes = item.get_array('BrowseNodes/BrowseNode/Name')
      small_image = item.get_element('SmallImage')
      medium_image = item.get_element('MediumImage')
      large_image = item.get_element('LargeImage')
      {
        vendor_id: vendor_id,
        vendor: VENDOR,
        vendor_name: VENDOR_NAME,
        name: HTMLEntities.new.decode(item_attributes.get('Title')),
        url: item.get('DetailPageURL'),
        image_url: small_image.blank? ? nil : small_image.get('URL'),
        medium_image_url: medium_image.blank? ? nil : medium_image.get('URL'),
        large_image_url: large_image.blank? ? nil : large_image.get('URL'),
        rating: nil,
        rating_count: 0,
        price: get_offer_price(item),
        sales_rank: item.get('SalesRank'),
        brand: item_attributes.get('Brand'),
        department: item_attributes.get('Department'),
        manufacturer: item_attributes.get('Manufacturer'),
        model: item_attributes.get('Model'),
        categories: browse_nodes.join(', '),
        mamajamas_rating: mamajamas_rating.present? ? mamajamas_rating.rating : nil,
        mamajamas_rating_count: mamajamas_rating.present? ? mamajamas_rating.rating_count : 0
      }
    end
  end
end
