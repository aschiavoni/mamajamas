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

  def update
    @product_type = ProductType.find(params[:id])
    @product_type.update_attributes!(params[:product_type])
    redirect_to edit_admin_product_type_path(@product_type)
  rescue ActiveRecord::RecordInvalid
    @view = Admin::ProductTypesView.new @product_type.category
    render :edit
  end

  protected

  def init_view
    set_subheader "Admin"
    set_page_id "adminpage"
    hide_progress_bar
  end
end
