class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_filter :require_basic_auth_maybe

  def facebook
    auth_info = request.env["omniauth.auth"]
    if current_user.present? && current_user.guest?
      unless FacebookUserFinder.find(auth_info)
        current_user.add_facebook_uid!(auth_info.uid)
      end
    end

    @user = FacebookUserCreator.from_oauth(auth_info)

    if @user.persisted?
      # TODO: background this?
      FacebookProfilePictureUpdater.new(@user).update!

      sign_in @user, :event => :authentication #this will throw if @user is not activated
      # set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
      session["devise.fb_access_token"] = auth_info.credentials.token
      session["devise.fb_access_token_expiration"] = auth_info.credentials.expires_at

      (render && return) if request.xhr?
      redirect_to registrations_facebook_path
    else
      session["devise.facebook_data"] = auth_info
      (render && return) if request.xhr?
      redirect_to new_user_registration_url
    end
  end
end
