class ListsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :init_view, only: [ :show ]
  before_filter :find_list

  respond_to :html, :json

  def show
    @view = ListView.new(@list, params[:category])
    @list_entries = @view.list_entries
    @list_entries_json = render_to_string(template: 'list_items/index',
                                          formats: :json)
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

  def init_view
    set_subheader "Your baby gear list"
    set_page_id "buildlist"
    set_progress_id 2
  end

  def find_list
    @list = current_user.list
    @list = current_user.build_list! if @list.blank?
  end
end
