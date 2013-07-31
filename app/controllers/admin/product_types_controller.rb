class Admin::ProductTypesController < Admin::BaseController
  def index
    @view = Admin::ProductTypesView.new Category.first
  end

  protected

  def init_view
    set_subheader "Admin"
    set_page_id "adminpage"
    hide_progress_bar
  end
end
