class EmailSettingsController < ApplicationController
  before_filter :authenticate_user!, except: [:unsubscribe]
  before_filter :no_guests, except: [:unsubscribe]
  before_filter :init_view, except: [:unsubscribe]

  def edit
    @settings = Forms::EmailSettingsView.new(current_user)
  end

  def update
    @settings = Forms::EmailSettingsView.new(current_user)
    if @settings.update!(params[:settings])
      flash[:notice] = "Your settings have been updated."
      redirect_to email_path
    else
      flash[:error] = "We could not save your settings. Please try again later."
      render action: "edit"
    end
  end

  def unsubscribe
    token = EmailAccessToken.read_access_token(params[:signature])
    if token
      user = User.find(token[:user_id])
      email_name = token[:email_name]
      user.update_attribute "#{email_name}_disabled".to_sym, true
      hide_header
      render
    else
      not_found
    end
  end

  private

  def init_view
    set_body_class "layout_2-7-3 form-page"
    set_subheader "My Settings"
  end
end
