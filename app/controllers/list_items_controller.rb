class ListItemsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_list
  before_filter :find_category

  respond_to :html, :json

  def index
    @list_items = find_list_items + find_product_types
    respond_to do |format|
      format.html
      format.json
    end
  end

  def edit
    @list_item = ListItem.new
  end

  def create
    @list_item = ListItem.create(
      params[:list_item].merge(list_id: @list.id)
    )

    respond_to do |format|
      format.html
      format.json
    end
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

  def find_product_types
    product_types = @list.product_types
    unless @category.blank?
      product_types = product_types.where(category_id: @category.id)
    end
    product_types
  end
end
