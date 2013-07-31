class Admin::ProductTypesController < Admin::BaseController
  before_filter :find_category

  def index
    @view = Admin::ProductTypesView.new @category
  end

  def edit
    @product_type = ProductType.find(params[:id])
    @view = Admin::ProductTypesView.new @product_type.category
  end

  def update
    @product_type = ProductType.find(params[:id])
    @product_type.update_attributes!(params[:product_type])
    flash[:notice] = "Updated #{@product_type.name}"
    redirect_to edit_admin_product_type_path(@product_type)
  rescue ActiveRecord::RecordInvalid
    @view = Admin::ProductTypesView.new @product_type.category
    render :edit
  end

  def new
    @product_type = ProductType.new(category_id: @category.id)
    @view = Admin::ProductTypesView.new @product_type.category
  end

  def create
    @product_type = ProductType.new(params[:product_type])
    @product_type.save!
    flash[:notice] = "Created #{@product_type.name}"
    redirect_to edit_admin_product_type_path(@product_type)
  rescue ActiveRecord::RecordInvalid
    @view = Admin::ProductTypesView.new @product_type.category
    render :new
  end

  protected

  def find_category
    if params[:category_id].present?
      @category = Category.find(params[:category_id])
    else
      @category = Category.order(:name).first
    end
  end

  def init_view
    set_subheader "Admin"
    set_page_id "adminpage"
    hide_progress_bar
  end
end
