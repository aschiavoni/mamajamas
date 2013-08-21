class ProductTypeSuggestionsController < ApplicationController
  before_filter :authenticate_user!

  respond_to :json

  def index
    product_type = ProductType.find_by_id(params[:id])
    if product_type.present?
      suggestions = CachedProductTypeSuggestions.find(product_type)
    else
      suggestions = { suggestions: [] }
    end
    respond_with suggestions[:suggestions]
  end
end
