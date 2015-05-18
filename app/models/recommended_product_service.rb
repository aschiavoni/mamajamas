class RecommendedProductService
  def self.create_or_update!(attrs)
    # { tag => { product attrs }, tag2 => { product attrs } }
    attrs.values.each do |product_attrs|
      product_attrs = product_attrs.symbolize_keys
      conditions = {
        product_type_id: product_attrs[:product_type_id],
        tag: product_attrs[:tag]
      }

      link = product_attrs[:link]
      override_name = product_attrs[:name]

      if link.present?
        amazon = CreatesRecommendedProductFromAmazonUrl.new(link, ecs_config)
        product_attrs = product_attrs.merge(amazon.product.symbolize_keys)
      end

      rp = RecommendedProduct.where(conditions).first
      if rp.present? && product_attrs[:link].blank?
        rp.destroy
        next
      end

      if product_attrs[:link].present?
        product_attrs[:name] = override_name if override_name.present?
        if rp.present?
          rp.update_attributes!(product_attrs)
        else
          rp = RecommendedProduct.create!(conditions.merge(product_attrs))
        end
      end
    end
  end

  private

  def self.ecs_config
    ProductFetcherConfiguration.for('amazon')
  end
end
