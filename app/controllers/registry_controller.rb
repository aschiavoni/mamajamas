class RegistryController < ApplicationController
  before_filter :authenticate_user!
  before_filter :init_view

  def edit
    @registry = Forms::RegistrySettings.new(current_user, current_user.list)
  end

  def update
    @registry = Forms::RegistrySettings.new(current_user, current_user.list)
    if @registry.update!(params[:registry])
      if current_user.list.present?
        redirect_to list_path
      else
        redirect_to quiz_path
      end
    else
      render action: "edit"
    end
  end

  private

  def init_view
    hide_header
    set_body_class "bgfill"
    set_nested_window
  end
end
