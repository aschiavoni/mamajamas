class Admin::ProductTypesController < Admin::BaseController
  before_filter :find_category

  def index
    @view = Admin::ProductTypesView.new @category
    respond_to do |format|
      format.html
      format.csv { render text: @view.csv }
    end
  end

  def edit
    @view = Admin::ProductTypeView.new ProductType.find(params[:id])
    @categories_view = Admin::ProductTypesView.new @view.product_type.category
  end

  def update
    @product_type = ProductType.find(params[:id])
    @product_type.update_attributes!(params[:product_type])
    recommended_products = params.delete(:recommended_products)
    if recommended_products.present?
      RecommendedProductService.create_or_update!(recommended_products)
    end
    flash[:notice] = "Updated #{@product_type.name}"
    redirect_to edit_admin_product_type_path(@product_type)
  rescue ActiveRecord::RecordInvalid
    flash[:error] = "Could not update #{@product_type.name}: #{@product_type.errors.first[1]}"
    @view = Admin::ProductTypesView.new @product_type.category
    render :edit
  end

  def new
    @view =
      Admin::ProductTypeView.new(ProductType.new(category_id: @category.id))
    @categories_view = Admin::ProductTypesView.new @view.product_type.category
  end

  def create
    @product_type = ProductType.new(params[:product_type])
    @product_type.save!
    flash[:notice] = "Created #{@product_type.name}"
    redirect_to edit_admin_product_type_path(@product_type)
  rescue ActiveRecord::RecordInvalid
    flash[:error] = "Could not update #{@product_type.name}: #{@product_type.errors.first[1]}"
    @view = Admin::ProductTypesView.new @product_type.category
    render :new
  end

  def destroy
    @product_type = ProductType.find(params[:id])
    if @product_type.admin_deleteable?
      @product_type.destroy
      flash[:notice] = "Deleted #{@product_type.name}"
      redirect_to admin_category_product_types_path(@product_type.category)
    else
      flash[:error] = "#{@product_type.name} is in use"
      redirect_to edit_admin_product_type_path(@product_type)
    end
  end

  protected

  def find_category
    if params[:category_id].present?
      @category = Category.find(params[:category_id])
    else
      @category = Category.order(:name).first
    end
  end
end
