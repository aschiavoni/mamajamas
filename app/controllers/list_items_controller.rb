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
    @list_item = @list.add_item(ListItem.new(params[:list_item]))
    respond_with @list_item
  end

  def update
    @list_item = ListItem.update(id_param, params[:list_item])
    respond_with @list_item
  end

  def destroy
    if params[:id] =~ /product-type/
      @list_entry = @list.list_product_types.where(product_type_id: id_param).first
      @list_entry.destroy unless @list_entry.blank?
    else
      @list_entry = @list.list_items.find(id_param).destroy
    end

    respond_with @list_entry
  end

  private

  def find_list
    @list ||= current_user.list
  end

  def find_category
    @category = params[:category].blank? ? nil : Category.find(params[:category])
  end

  def id_param
    # id may be prefixed with list-item- or product-type-
    params[:id].gsub(/(list-item-|product-type-)/, "")
  end
end
