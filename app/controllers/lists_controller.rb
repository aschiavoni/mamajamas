class ListsController < ApplicationController
  before_filter :authenticate_user!

  def show
    @page_id = "buildlist"
    @categories = Category.all
    @category = @categories.first
  end
end
