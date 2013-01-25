class UsersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :init_view

  def edit
  end

  def update
    respond_to do |format|
      if UserProfileUpdater.new(@user).update(params[:user], params[:list])
        format.html do
          redirect_to profile_path, notice: "Your profile has been updated."
        end
      else
        format.html do
          render action: "edit"
        end
      end
    end
  end

  private

  def init_view
    @user = current_user
    @page_id = "create-profile"
    @subheader = "Create my profile"
  end
end
