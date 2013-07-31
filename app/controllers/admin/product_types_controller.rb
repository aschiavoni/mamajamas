class Admin::ProductTypesController < Admin::BaseController
  def index
  end

  protected

  def init_view
    set_subheader "Admin"
    hide_progress_bar
  end
end
