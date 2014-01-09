class ListRecommendationService
  def initialize(user)
    @user = user
  end

  def update!
    list = user.list
    conditions = "priority < 3"
    list.list_items.placeholders.where(conditions).each do |placeholder|
      rps = recommended_products[placeholder.product_type_id]
      replace_placeholder(placeholder, rps.sample) if rps.size > 0
    end
  end

  def replace_placeholder(placeholder, recommended_product)
    placeholder.update_attributes!({
                                     name: recommended_product.name,
                                     link: recommended_product.link,
                                     vendor: recommended_product.vendor,
                                     vendor_id: recommended_product.vendor_id,
                                     image_url: recommended_product.image_url,
                                     placeholder: false
                                   })
  end

  private

  def user
    @user
  end

  def recommended_products
    @recommended_products ||= build_recommended_products_hash
  end

  # we are only using 3 tags for recommended products for now
  def build_recommended_products_hash
    h = Hash.new { |hsh, key| hsh[key] = [] }
    tags = [ "eco", "cost", "extra" ]
    RecommendedProduct.where(tag: tags).each do |rp|
      h[rp.product_type_id] << rp
    end
    h
  end
end
