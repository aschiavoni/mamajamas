class ListSettingsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :no_guests
  before_filter :init_view

  def edit
    @settings = Forms::ListSettingsView.new(current_user)
  end

  def update
    @settings = Forms::ListSettingsView.new(current_user)
    if @settings.update!(params[:settings])
      flash[:notice] = "Your settings have been updated."
      redirect_to settings_path
    else
      flash[:error] = "We could not save your settings. Please try again later."
      render action: "edit"
    end
  end

  private

  def init_view
    set_body_class "layout_2-7-3 form-page"
    set_subheader "My Settings"
  end
end
