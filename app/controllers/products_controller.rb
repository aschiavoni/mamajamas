class ProductsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :no_guests

  respond_to :json

  def index
    query = params[:filter]
    cache_id = "product:searcher:#{query.parameterize}"
    @products = Rails.cache.fetch(cache_id, expire_in: 24.hours) do
      ProductSearcher.search(query, 4)
    end

    respond_to do |format|
      format.html { not_found }
      format.json
    end
  end
end
