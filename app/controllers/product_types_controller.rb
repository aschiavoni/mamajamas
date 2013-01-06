class ProductTypesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_category

  respond_to :json

  def index
    @product_types = @category.product_types

    respond_to do |format|
      format.html { not_found }
      format.json
    end
  end

  def create
    @product_type = ProductType.new(params[:product_type])
    current_user.product_types << @product_type
    respond_with @product_type
  end

  private

  def find_category
    @category = Category.find(params[:category_id])
  end
end
