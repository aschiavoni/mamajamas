class Admin::UsersController < Admin::BaseController
  def index
    @view = Admin::UsersView.new
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to admin_users_path
  end
end
