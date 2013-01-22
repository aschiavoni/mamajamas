class ListEntriesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_list

  respond_to :json

  def create
    @list_entry = @list.add_list_item(ListItem.new(clean_params(params[:list_entry])))
    respond_with @list_entry
  end

  def update
    @list_entry = @list.list_items.find(params[:id])
    @list_entry.update_attributes!(clean_params(params[:list_entry]))
    respond_with @list_entry
  end

  def destroy
    @list_entry = @list.list_items.find(params[:id]).destroy
    respond_with @list_entry
  end

  private

  def find_list
    @list ||= current_user.list
  end

  def clean_params(params_to_clean)
    [ :id, :placeholder, :category, :product_type, :when_to_buy_position ].each do |key|
      params_to_clean.delete(key)
    end
    params_to_clean
  end
end
