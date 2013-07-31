class Admin::ProductTypesController < Admin::BaseController
  def index
    if params[:category].present?
      @category = Category.find(params[:category])
    end
    @view = Admin::ProductTypesView.new @category
  end

  def edit
    @product_type = ProductType.find(params[:id])
    @view = Admin::ProductTypesView.new @product_type.category
  end

  protected

  def init_view
    set_subheader "Admin"
    set_page_id "adminpage"
    hide_progress_bar
  end
end
