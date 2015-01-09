class RecommendedProductsController < ApplicationController
  before_filter :authenticate_user!

  respond_to :json

  def index
    @recommended_products = recommended_products
    respond_with @recommended_products
  end

  def create
    @list_item = service.add_recommendation(params[:id])
    respond_with @list_item
  end

  def add_all
    @list_item_ids = service.add_recommendations(params[:recs])
    render json: @list_item_ids.to_json
  end

  private

  def recommended_products
    service.random_recommended_products.values
  end

  def service
    @service ||= ListRecommendationService.new(current_user)
  end
end
