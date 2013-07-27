class ProductsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :no_guests

  respond_to :json

  def index
    @products = []
    query = search_query(params[:filter], params[:name])

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

  private

  def search_query(query, product_type_name)
    return query if product_type_name.blank?
    name = product_type_name.downcase
    if query != name && query.split(' ').size == 1
      query += " #{name}"
    end
    query
  end
end
