class ListRecommendationService
  def initialize(user, category = nil)
    @user = user
    @category = category
  end

  def update!
    list = user.list
    conditions = "priority < 3"
    list.list_items.placeholders.where(conditions).each do |placeholder|
      product = random_recommended_products[placeholder.product_type_id]
      replace_placeholder(placeholder, product[:recommended_product]) if product.present?
    end
  end

  def add_recommendation(recommendation_id)
    recommended_product = RecommendedProduct.
      includes(:product_type).
      find(recommendation_id)

    placeholder = @user.list.
      list_items.
      placeholders.
      find_by(product_type_id: recommended_product.product_type_id)

    if placeholder.blank?
      list = user.list
      placeholder =
        list.add_list_item_placeholder(recommended_product.product_type)
    end

    replace_placeholder(placeholder, recommended_product)
  end

  def add_recommendations(recommendation_ids)
    recommendations = RecommendedProduct.where(id: recommendation_ids)
    placeholders = Hash[user.list.list_items.placeholders.map { |p|
                          [ p.product_type_id, p ]
                        }]

    ids = []
    recommendations.each do |rec|
      placeholder = placeholders[rec.product_type_id]
      if placeholder.present?
        list_item = replace_placeholder(placeholder, rec)
        ids << list_item.id if list_item.present?
      end
    end
    ids
  end

  def random_recommended_products
    @random_products ||= build_random_recommended_products
  end

  def clear_recommendations!
    list = user.list
    list_items = list.list_items.recommended

    if category.present?
      list_items = list_items.where(category_id: category.id)
    end

    list_items.recommended.each do |list_item|
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
                                     priority: 1,
                                     recommended: true
                                   })
    placeholder
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

  def recommended_products
    @recommended_products ||= build_recommended_products_hash
  end

  def product_type_ids
    @product_type_ids ||= user.
      list.
      list_items.
      placeholders.
      select(:product_type_id).
      uniq.
      map(&:product_type_id)
  end

  private

  def user
    @user
  end

  def category
    @category
  end

  def build_recommended_products_hash
    h = Hash.new { |hsh, key| hsh[key] = [] }
    tags = [ "eco", "cost", "extra", "twins" ]
    return h if user.list.blank?

    RecommendedProduct.
      joins(product_type: :age_range).
      includes(product_type: :age_range).
      where(tag: tags, product_type_id: product_type_ids).
      where(hidden: false).
      order("product_types.rank ASC").each do |rp|

      h[rp.product_type_id] << {
                                recommended_product: rp,
                                product_type: rp.product_type,
                                age_range: rp.product_type.age_range,
                                rank: rp.product_type.rank
                               }
    end
    h
  end

  def build_random_recommended_products
    random_products = {}
    recommended_products.each do |product_type_id, items|
      if user.has_multiples? &&
          (twins_rec = items.select { |rp| rp[:recommended_product].tag == "twins" }.first).present?
        random_products[product_type_id] = twins_rec
      else
        random_products[product_type_id] = items.sample
      end
    end
    random_products
  end

end
