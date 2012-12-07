class ListItemsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_list
  before_filter :find_category

  respond_to :json

  def index
    @list_entries = @list.list_entries(@category)
    respond_with @list_entries
  end

  def create
    @list_item = ListItem.create(
      params[:list_item].merge(list_id: @list.id)
    )
    respond_with @list_item
  end

  def update
    @list_item = ListItem.update(id_param, params[:list_item])
    respond_with @list_item
  end

  def destroy
    @list_item = @list.list_items.find(id_param).destroy
    respond_with @list_item
  end

  private

  def find_list
    @list ||= current_user.list
  end

  def find_category
    @category = params[:category].blank? ? nil : Category.find(params[:category])
  end

  def id_param
    # id may be prefixed with list-item-
    params[:id].gsub(/list-item-/, "")
  end
end
