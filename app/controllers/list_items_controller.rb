class ListItemsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_list
  before_filter :find_category

  respond_to :html, :json

  def index
    @list_items = find_list_items
    respond_to do |format|
      format.html
      format.json
    end
  end

  def edit
    @list_item = ListItem.new
  end

  def create
    logger.info params.inspect
    render :json => { status: "ok" }
  end

  private

  def find_list
    @list ||= current_user.list
  end

  def find_category
    @category = params[:category].blank? ? nil : Category.find(params[:category])
  end

  def find_list_items
    list_items = @list.list_items
    unless @category.blank?
      list_items = list_items.where(category_id: @category.id)
    end
    list_items
  end
end
