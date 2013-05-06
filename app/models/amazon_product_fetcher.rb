class AmazonProductFetcher
  def initialize(options = {})
    Amazon::Ecs.options = {
      associate_tag: options["associate_tag"],
      AWS_access_key_id: options["access_key_id"],
      AWS_secret_key: options["secret_key"]
    }
  end

  def fetch(query, options = { pages: 1 })
    results = []

    options[:pages].times do |i|
      # simple throttle so we don't abuse the api
      sleep 1.1

      res = Amazon::Ecs.item_search(query, {
        :response_group => 'Large',
        :search_index => 'Baby',
        :item_page => i + 1
      })

      results << res.items.each_with_index.map do |item, idx|
        # return Amazon::Element instance
        item_attributes = item.get_element('ItemAttributes')
        browse_nodes = item.get_array('BrowseNodes/BrowseNode/Name')
        small_image = item.get_element('SmallImage')
        {
          vendor_id: item.get('ASIN'),
          vendor: "amazon",
          name: item_attributes.get('Title'),
          url: item.get('DetailPageURL'),
          image_url: small_image.blank? ? nil : small_image.get('URL'),
          rating: nil,
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
end
