class RecommendedProductsController < ApplicationController
  before_filter :authenticate_user!

  respond_to :json

  def index
    @recommended_products = recommended_products
    respond_with @recommended_products
  end

  private

  def recommended_products
    service = ListRecommendationService.new(current_user)
    service.random_recommended_products.values
  end
end
