class AdminController < ApplicationController
  before_filter :authenticate_user!

  def become
    return unless current_user.admin?
    sign_in(:user, User.find_by_username(params[:username]))
    redirect_to list_path
  end
end
