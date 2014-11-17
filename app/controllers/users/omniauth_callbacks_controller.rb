class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_filter :require_basic_auth_maybe

  def facebook
    oauth = OmniauthHashParser.new(request.env["omniauth.auth"])

    if current_user.present?
      unless OauthUserFinder.find(oauth)
        AddsAuthentication.new(current_user).add("facebook", uid: oauth.uid)
        unless current_user.guest?
          # if we are logged in and not a guest, we just connected
          # facebook to an existing user and we do not want to
          # process the rest of the action
          @user = current_user
          # TODO: background this?
          FacebookProfilePictureUpdater.new(@user, oauth.uid).update!
          cookies[:after_sign_in_path] = list_path
          (render && return) if request.xhr?
          redirect_to registrations_facebook_path and return
        end
      end
    end

    @user = OauthUserCreator.from_oauth(oauth)

    if @user.persisted?
      # TODO: background this?
      FacebookProfilePictureUpdater.new(@user, oauth.uid).update!
      EmailSubscriptionUpdaterWorker.perform_in(5.minutes, @user.id)

      sign_in @user, :event => :authentication #this will throw if @user is not activated
      # set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
      session["devise.fb_access_token"] = oauth.access_token
      session["devise.fb_access_token_expiration"] = oauth.access_token_expires_at

      cookies[:after_sign_in_path] = registry_path

      (render && return) if request.xhr?
      redirect_to registrations_facebook_path
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      (render && return) if request.xhr?
      redirect_to new_user_registration_url
    end
  end

  def google
    oauth = OmniauthHashParser.new(request.env["omniauth.auth"])

    if current_user.present?
      unless OauthUserFinder.find(oauth)
        AddsAuthentication.new(current_user).from_oauth(oauth)
        unless current_user.guest?
          # if we are logged in and not a guest, we just connected
          # google to an existing user and we do not want to
          # process the rest of the action
          @user = current_user
          (render && return) if request.xhr?
          redirect_to after_sign_in_path_for(@user) and return
        end
      end
    end

    @user = OauthUserCreator.from_oauth(oauth)

    if @user.persisted?
      sign_in @user, :event => :authentication #this will throw if @user is not activated
      (render && return) if request.xhr?
      redirect_to after_sign_in_path_for(@user)
    else
      (render && return) if request.xhr?
      redirect_to after_sign_in_path_for(@user)
    end
  end

end
