class ListItemsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_list
  before_filter :find_category, only: [ :index ]
  before_filter :set_cache_buster, only: [ :index ]
  before_filter :init_view, only: [ :gifts ]

  respond_to :json

  def index
    @list_entries = @list.list_entries(@category)
    respond_with @list_entries
  end

  def create
    placeholder = params[:list_item].delete(:placeholder)
    item_params = clean_params(params[:list_item])
    @list_entry = @list.add_list_item(ListItem.new(item_params), placeholder)
    if @list_entry.persisted? && !current_user.guest?
      FollowerNotificationWorker.perform_in(4.hours, current_user.id)
    end
    respond_with @list_entry
  end

  def update
    @list_entry = @list.list_items.find(params[:id])
    update_params = clean_params(params[:list_item]).merge(recommended: false)
    @list_entry.update_attributes(update_params)
    respond_with @list_entry
  end

  def destroy
    @list_entry = @list.list_items.find(params[:id]).destroy
    respond_with @list_entry
  end

  def gifts
    @list_item = @list.list_items.includes(:gifts).find(params[:id])
    @owner = @list.user
  end

  private

  def find_list
    @list ||= current_user.list
  end

  def find_category
    @category = params[:category].blank? ? nil : Category.find(params[:category])
  end

  def clean_params(params_to_clean)
    [ :id, :category, :product_type, :age_position  ].each do |key|
      params_to_clean.delete(key)
    end
    params_to_clean[:owned] = false if params_to_clean[:owned].blank?
    params_to_clean
  end

  def init_view
    hide_header
    set_body_class "bgfill"
    set_nested_window
  end
end
