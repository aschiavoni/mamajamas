class ListItemsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_list
  before_filter :find_category

  respond_to :json

  def index
    @list_entries = @list.list_items.by_category(@category) + @list.product_types.by_category(@category)
    respond_with @list_entries
  end

  def create
    @list_item = ListItem.create(
      params[:list_item].merge(list_id: @list.id)
    )
    respond_with @list_item
  end

  def update
    @list_item = ListItem.update(params[:id], params[:list_item])
    respond_with @list_item
  end

  private

  def find_list
    @list ||= current_user.list
  end

  def find_category
    @category = params[:category].blank? ? nil : Category.find(params[:category])
  end
end
