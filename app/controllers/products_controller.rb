class ProductsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :no_guests
  before_filter :find_product_type

  respond_to :json

  def index
    @products = AvailableProducts.new.find(@product_type, params[:filter], 20)

    respond_to do |format|
      format.html { not_found }
      format.json
    end
  end

  private

  def find_product_type
    @category = Category.find(params[:category_id])
    @product_type = @category.product_types.find_by_id(params[:product_type_id])
  end
end
