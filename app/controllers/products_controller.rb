class ProductsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :no_guests

  respond_to :json

  def index
    @products = ProductSearcher.search(params[:filter])

    respond_to do |format|
      format.html { not_found }
      format.json
    end
  end
end
