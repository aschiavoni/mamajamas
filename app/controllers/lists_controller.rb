class ListsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_list

  respond_to :html, :json

  def show
    @subheader = "Your baby gear list"
    @page_id = "buildlist"
    @categories = @list.categories.for_list

    if params[:category].present?
      @category = @categories.by_slug(params[:category]).first
    else
      @category = @categories.first
    end

    @list_entries = @list.list_entries(@category)
    @list_entries_json = render_to_string(template: 'list_items/index', formats: :json)

    respond_to do |format|
      format.html
    end
  end

  def product_types
    @available_product_types = @list.available_product_types(params[:filter], 20)

    respond_to do |format|
      format.html { not_found }
      format.json
    end
  end

  private

  def find_list
    @list = current_user.list
    @list = current_user.build_list! if @list.blank?
  end
end
