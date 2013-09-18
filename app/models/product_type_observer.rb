class ProductTypeObserver < ActiveRecord::Observer
  observe :product_type

  def before_save(product_type)
    product_type.image_name.downcase!
  end
end
