class ListsController < ApplicationController
  before_filter :authenticate_user!

  respond_to :html, :json

  def show
    @subheader = "Your baby gear list"
    @page_id = "buildlist"
    @list = current_user.list
    @categories = @list.categories.for_list
    @category = params[:category].blank? ? @categories.first : @categories.where(slug: params[:category]).first
    @product_types = @list.product_types.where(category_id: @category.id)

    @list_entries = @list.list_entries(@category)
    @list_entries_json = render_to_string(template: 'list_items/index', formats: :json)

    respond_to do |format|
      format.html
    end
  end

  def product_types
    @list = current_user.list
    @available_product_types = @list.available_product_types
    if params[:filter].present?
      @available_product_types = @available_product_types.select do |product_type|
        product_type.name.downcase =~ /#{params[:filter].downcase}/
      end
    end

    respond_to do |format|
      format.html { not_found }
      format.json
    end
  end
end
