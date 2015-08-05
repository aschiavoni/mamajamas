class ProductsController < ApplicationController
  before_filter :authenticate_user!

  respond_to :json

  def index
    @products = []
    limit = 4
    raw_query = params[:filter]
    query = search_query(raw_query, params[:name])

    if query.present?
      cache_id = "product:searcher:#{query.parameterize}"
      @products = Rails.cache.fetch(cache_id, expire_in: 24.hours) do
        ProductSearcher.search(query, 'All', limit)
      end

      if @products.size < limit
        add = limit - @products.size
        @products = @products + Product.search_by_name(raw_query).limit(add)
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
    if query.split.size < 3
      name = product_type_name.downcase
      query += " #{name}" if query != name
    end
    query
  end
end
