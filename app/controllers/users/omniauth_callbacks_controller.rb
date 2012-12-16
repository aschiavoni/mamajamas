class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_filter :require_basic_auth_maybe

  def facebook
    auth_info = request.env["omniauth.auth"]
    @user = FacebookUserCreator.from_oauth(request.env["omniauth.auth"], current_user)

    if @user.persisted?
      sign_in @user, :event => :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
      session["devise.fb_access_token"] = auth_info.credentials.token
      session["devise.fb_access_token_expiration"] = auth_info.credentials.expires_at

      (render && return) if request.xhr?
      redirect_to registrations_facebook_path
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      (render && return) if request.xhr?
      redirect_to new_user_registration_url
    end
  end
end
