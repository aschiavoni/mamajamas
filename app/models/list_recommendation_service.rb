class ListRecommendationService
  def initialize(user)
    @user = user
  end

  def update!
    list = user.list
    conditions = "priority < 3"
    list.list_items.placeholders.where(conditions).each do |placeholder|
      rps = recommended_products[placeholder.product_type_id]

      if rps.size > 0
        if user.has_multiples? &&
            (twins_rec = rps.select { |rp| rp.tag == "twins" }.first).present?
          replace_placeholder(placeholder, twins_rec)
        else
          replace_placeholder(placeholder, rps.sample)
        end
      end
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

  def build_recommended_products_hash
    h = Hash.new { |hsh, key| hsh[key] = [] }
    tags = [ "eco", "cost", "extra", "twins" ]
    RecommendedProduct.where(tag: tags).each do |rp|
      h[rp.product_type_id] << rp
    end
    h
  end
end
