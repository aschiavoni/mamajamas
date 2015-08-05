class CreatesRecommendedProductFromAmazonUrl
  attr_reader :url
  attr_reader :vendor_id

  def initialize(url, ecs_options = {})
    @vendor_id = :not_found
    @url = parse_url(url)

    Amazon::Ecs.options = {
      associate_tag: ecs_options["associate_tag"],
      AWS_access_key_id: ecs_options["access_key_id"],
      AWS_secret_key: ecs_options["secret_key"]
    }
  end

  def product
    product = {}
    return product if vendor_id == :not_found
    item = Amazon::Ecs.item_lookup(vendor_id, {
                                     :response_group => "Large",
                                   }).items.first

    if item.present?
      item_attrs = item.get_element("ItemAttributes")

      product.merge!({
                       vendor: "amazon",
                       link: item.get("DetailPageURL"),
                       vendor_id: item.get("ASIN"),
                       name: HTMLEntities.new.decode(item_attrs.get("Title")),
                       image_url: image_url(item),
                       price: get_offer_price(item)
                     })
    end

    product
  end

  private

  def parse_url(url)
    u = URI(url)
    if u.path =~ /\/dp\/(.*)(%3F|\/)/
      @vendor_id = $1
    elsif u.path =~ /\/gp\/product\/(.*)\//
      @vendor_id = $1
    end
    url
  end

  def image_url(item, size = :medium)
    elem_name = "#{size.to_s.capitalize}Image"
    image = item.get_element(elem_name)
    image.blank? ? nil : image.get("URL")
  end

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
end
