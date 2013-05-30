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

  def initialize(logger = ProductFetcherLogger, options = {})
    @logger = logger
    Amazon::Ecs.options = {
      associate_tag: options["associate_tag"],
      AWS_access_key_id: options["access_key_id"],
      AWS_secret_key: options["secret_key"]
    }
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

      results << res.items.each_with_index.map do |item, idx|
        # return Amazon::Element instance
        item_attributes = item.get_element('ItemAttributes')
        browse_nodes = item.get_array('BrowseNodes/BrowseNode/Name')
        small_image = item.get_element('SmallImage')
        medium_image = item.get_element('MediumImage')
        large_image = item.get_element('LargeImage')
        {
          vendor_id: item.get('ASIN'),
          vendor: "amazon",
          name: item_attributes.get('Title'),
          url: item.get('DetailPageURL'),
          image_url: small_image.blank? ? nil : small_image.get('URL'),
          medium_image_url: medium_image.blank? ? nil : medium_image.get('URL'),
          large_image_url: large_image.blank? ? nil : large_image.get('URL'),
          rating: nil,
          price: get_price(item),
          sales_rank: item.get('SalesRank'),
          brand: item_attributes.get('Brand'),
          department: item_attributes.get('Department'),
          manufacturer: item_attributes.get('Manufacturer'),
          model: item_attributes.get('Model'),
          categories: browse_nodes.join(', ')
        }
      end
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
end
