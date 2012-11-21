class CategoriesController < ApplicationController
  before_filter :authenticate_user!

  respond_to :json

  def index
    @categories = Category.all
  end
end
