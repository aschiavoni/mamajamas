class ListBuilder
  def initialize(user)
    @user = user
  end

  def build!
    list = List.new
    list.user = @user

    # for now, we are just adding all product types
    ProductType.global.each do |product_type|
      list.list_product_types << ListProductType.new({
        product_type: product_type,
        category: product_type.category
      })
    end

    list.save!
    list
  end
end
