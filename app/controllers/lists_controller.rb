class ListsController < ApplicationController
  before_filter :authenticate_user!

  def show
    @page_id = "buildlist"
    @list = current_user.list
    @categories = @list.categories.for_list
    @category = params[:category].blank? ? @categories.first : @categories.where(slug: params[:category]).first
    @product_types = @list.product_types.where(category_id: @category.id)
  end
end
