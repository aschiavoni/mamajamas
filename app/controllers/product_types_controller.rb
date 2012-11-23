class ProductTypesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_category

  respond_to :json

  def index
    @product_types = @category.product_types
  end

  private

  def find_category
    @category = Category.find(params[:category_id])
  end
end
