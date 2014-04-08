class Admin::UsersController < Admin::BaseController
  def index
    @view = Admin::UsersView.new

    respond_to do |format|
      format.html
      format.csv { render text: @view.registered_csv }
    end
  end

  def show
    @user = User.find(params[:id])
    @view = Admin::UserView.new(@user)
  end

  def update
    user = User.find(params[:id])
    user.update_attributes!(params[:user])
    user.list.update_attributes!(params[:list], as: :admin)
    if request.xhr?
      render json: user
    else
      redirect_to admin_user_path(params[:id])
    end
  end

  def update_notes
    admin_notes = params[:user][:admin_notes]
    user = User.find(params[:id])
    user.update_attributes!(admin_notes: admin_notes)
    redirect_to admin_user_path(params[:id])
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to admin_users_path
  end
end
