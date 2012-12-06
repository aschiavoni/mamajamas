class ListsController < ApplicationController
  before_filter :authenticate_user!

  def show
    @page_id = "buildlist"
    @list = current_user.list
    @categories = @list.categories.for_list
    @category = params[:category].blank? ? @categories.first : @categories.where(slug: params[:category]).first
    @product_types = @list.product_types.where(category_id: @category.id)

    @list_entries = @list.list_entries(@category)
    @list_entries_json = render_to_string(template: 'list_items/index', formats: :json)

    respond_to do |format|
      format.html
    end
  end
end
