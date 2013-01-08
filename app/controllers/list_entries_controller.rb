class ListEntriesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_list

  respond_to :json

  def create
    entry_params = params[:list_entry]
    entry_type = entry_params.delete(:type)
    if entry_type == "ListItem"
      entry_params.delete(:product_type)
      @list_entry = @list.add_list_item(ListItem.new(entry_params))
    elsif entry_type == "ProductType"
      @list_entry = @list.add_product_type(ProductType.new(entry_params))
    end
    respond_with @list_entry
  end

  def update
    # currently only support updating list_items
    @list_entry = @list.list_items.find(id_param)
    @list_entry.update_attributes!(clean_params(params[:list_entry]))
    respond_with @list_entry
  end

  def destroy
    if params[:id] =~ /product-type/
      @list_entry = @list.list_product_types.where(product_type_id: id_param).first
      @list_entry.hide! unless @list_entry.blank?
    else
      @list_entry = @list.list_items.find(id_param).destroy
    end

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
