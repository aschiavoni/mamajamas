class ProductsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :no_guests

  respond_to :json

  def index
    @products = []
    query = params[:filter]
    if query.present?
      cache_id = "product:searcher:#{query.parameterize}"
      @products = Rails.cache.fetch(cache_id, expire_in: 24.hours) do
        ProductSearcher.search(query, 'All', 4)
      end
    end

    respond_to do |format|
      format.html { not_found }
      format.json
    end
  end
end
