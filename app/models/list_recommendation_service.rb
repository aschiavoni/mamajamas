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

  def clear_recommendations!
    list = user.list
    list.list_items.recommended.each do |list_item|
      restore_placeholder(list_item)
    end
  end

  def replace_placeholder(placeholder, recommended_product)
    product_type = recommended_product.product_type
    rank = product_type.present? ? product_type.rank : nil
    placeholder.update_attributes!({
                                     name: recommended_product.name,
                                     link: recommended_product.link,
                                     vendor: recommended_product.vendor,
                                     vendor_id: recommended_product.vendor_id,
                                     image_url: recommended_product.image_url,
                                     price: recommended_product.price,
                                     placeholder: false,
                                     rank: rank,
                                     recommended: true
                                   })
  end

  def restore_placeholder(list_item)
    image_name = if list_item.product_type.present?
                   list_item.product_type.image_name
                 else
                   'products/icons/unknown.png'
                 end
    rank = if list_item.product_type.present?
             list_item.product_type.rank
           else
             nil
           end
    list_item.update_attributes!({
                                   name: nil,
                                   link: nil,
                                   owned: false,
                                   rating: 0,
                                   notes: nil,
                                   image_url: image_name,
                                   placeholder: true,
                                   rank: rank,
                                   recommended: false
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
