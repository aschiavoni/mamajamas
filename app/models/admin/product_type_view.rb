class Admin::ProductTypeView
  attr_reader :product_type

  def initialize(product_type)
    @product_type = product_type
  end

  def recommended_products
    h = {}
    product_type.recommended_products.each do |rp|
      h[rp.tag.to_sym] = rp
    end

    [ :eco, :upscale, :cost, :extra, :twins ].each do |t|
      if h[t].blank?
        h[t] = product_type.recommended_products.build(tag: t.to_s)
      end
    end

    h
  end

end
