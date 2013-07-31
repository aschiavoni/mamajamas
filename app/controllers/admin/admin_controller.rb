class Admin::AdminController < Admin::BaseController
  def index
  end

  def become
    return unless current_user.admin?
    sign_in(:user, User.find_by_username(params[:username]))
    redirect_to list_path
  end

  protected

  def init_view
    set_subheader "Admin"
    hide_progress_bar
  end
end
