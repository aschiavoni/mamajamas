class ProductsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_product_type

  respond_to :json

  def index
    @products = @product_type.products
  end

  private

  def find_product_type
    @category = Category.find(params[:category_id])
    @product_type = @category.product_types.find(params[:product_type_id])
  end
end
