class Admin::ProductTypeView
  attr_reader :product_type

  def initialize(product_type)
    @product_type = product_type
  end
end
