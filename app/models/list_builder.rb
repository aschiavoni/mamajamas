class ListBuilder
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def build!(product_types = ProductType.global)
    list = List.new
    list.user = user

    # for now, we are just adding all product types
    product_types.each do |product_type|
      list.add_list_item_placeholder(product_type)
    end

    list.save!
    list
  end
end
