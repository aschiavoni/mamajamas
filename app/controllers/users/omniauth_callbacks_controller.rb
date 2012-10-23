class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    auth_info = request.env["omniauth.auth"]
    logger.debug auth_info.to_yaml
    @user = User.find_for_facebook_oauth(request.env["omniauth.auth"], current_user)

    if @user.persisted?
      sign_in @user, :event => :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
      session["devise.fb_access_token"] = auth_info.credentials.token
      session["devise.fb_access_token_expiration"] = auth_info.credentials.expires_at

      # TODO: background this...
      @user.facebook.refresh_access_token
      redirect_to users_facebook_path
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end
end
