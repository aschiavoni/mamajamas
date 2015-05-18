class Admin::BaseController < ApplicationController
  before_filter :authenticate_user!
  before_filter :require_admin!
  before_filter :init_view

  protected

  def require_admin!
    unless current_user && current_user.admin?
      render :file => "public/401", status: :unauthorized, layout: false
    end
  end

  def init_view
    set_subheader "Admin"
    set_page_id "adminpage"
  end
end
