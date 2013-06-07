class ListsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :init_view, only: [ :show ]
  before_filter :find_list, only: [ :show, :product_types ]

  caches_action :suggestions

  respond_to :html, :json

  def show
    if @list.blank?
      redirect_to(quiz_path) and return
    end

    @view = ListView.new(@list, params[:category])
    @list_entries_json = render_to_string(
      template: 'list_items/index',
      formats: :json,
      locals: { list_entries: @view.list_entries })

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

  def suggestions
    category_slug = params[:category]
    cat = Category.find_by_slug(category_slug) unless category_slug.blank?
    product_types = cat.present? ? cat.product_types : ProductType.scoped

    suggestions = product_types.map do |product_type|
      CachedProductTypeSuggestions.find(product_type)
    end

    respond_to do |format|
      format.html { not_found }
      format.json { render json: suggestions }
    end
  end

  private

  def init_view
    set_subheader "Your baby gear list"
    set_page_id "buildlist"
    set_progress_id 2
  end

  def find_list
    @list = current_user.list
  end
end
