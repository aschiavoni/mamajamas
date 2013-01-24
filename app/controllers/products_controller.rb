class ProductsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_product_type

  respond_to :json

  def index
    @products = @product_type.present? ? @product_type.available_products : Product.active
    unless params[:filter].blank?
      @products = @products.where("lower(name) LIKE ?", "%#{params[:filter].downcase}%")
    end
    @products = @products.limit(20)

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
