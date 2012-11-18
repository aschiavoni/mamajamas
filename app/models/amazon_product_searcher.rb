class AmazonProductSearcher
  def initialize(options = {})
    Amazon::Ecs.options = {
      associate_tag: options["associate_tag"],
      AWS_access_key_id: options["access_key_id"],
      AWS_secret_key: options["secret_key"]
    }
  end

  def search(query)
    res = Amazon::Ecs.item_search(query, {
      :response_group => 'Large',
      :search_index => 'Baby'
    })

    res.items.each_with_index.map do |item, idx|
      # return Amazon::Element instance
      item_attributes = item.get_element('ItemAttributes')
      Product.new({
        name: item_attributes.get('Title'),
        id: item.get('ASIN'),
        link: item.get('DetailPageURL'),
        rating: nil
      })
    end
  end
end
