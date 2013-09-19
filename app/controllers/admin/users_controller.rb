class Admin::UsersController < Admin::BaseController
  def index
    @view = Admin::UsersView.new

    respond_to do |format|
      format.html
      format.csv { render text: @view.registered_csv }
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to admin_users_path
  end
end
