class Admin::AdminController < Admin::BaseController
  def index
  end

  def become
    sign_in(:user, User.find_by_username(params[:username]))
    redirect_to list_path
  end

  protected

  def init_view
    set_subheader "Admin"
    set_page_id "adminpage"
    hide_mainnav
  end
end
