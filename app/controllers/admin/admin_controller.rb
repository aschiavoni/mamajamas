class AdminController < ApplicationController
  before_filter :authenticate_user!
  before_filter :require_admin!

  def index
  end

  def become
    return unless current_user.admin?
    sign_in(:user, User.find_by_username(params[:username]))
    redirect_to list_path
  end

  protected

  def require_admin!
    unless current_user && current_user.admin?
      render :file => "public/401", status: :unauthorized, layout: false
    end
  end
end
