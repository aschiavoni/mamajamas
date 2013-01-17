class UsersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :init_view

  def edit
  end

  def update
    respond_to do |format|
      if @user.update_attributes(params[:user]) && @user.list.update_attributes(params[:list])
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
