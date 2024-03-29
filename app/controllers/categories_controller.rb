class CategoriesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :no_guests

  respond_to :json

  def index
    @categories = Category.all

    respond_to do |format|
      format.html { not_found }
      format.json
    end
  end
end
