class ListEntriesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_list

  respond_to :json

  def create
    @list_entry = @list.add_list_item(ListItem.new(params[:list_entry]))
    respond_with @list_entry
  end

  def update
    # currently only support updating list_items
    @list_entry = @list.list_items.find(id_param)
    @list_entry.update_attributes!(clean_params(params[:list_entry]))
    respond_with @list_entry
  end

  def destroy
    @list_entry = @list.list_items.find(id_param).destroy
    respond_with @list_entry
  end

  private

  def find_list
    @list ||= current_user.list
  end

  def id_param
    # id may be prefixed with list-item- or product-type-
    params[:id].gsub(/(list-item-|product-type-)/, "")
  end

  def clean_params(params_to_clean)
    [ :id, :type, :category, :product_type, :when_to_buy_position ].each do |key|
      params_to_clean.delete(key)
    end
    params_to_clean
  end
end
