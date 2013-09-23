class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_filter :require_basic_auth_maybe
  before_filter :authenticate_user!, only: [ :google ]

  def facebook
    oauth = OmniauthHashParser.new(request.env["omniauth.auth"])

    if current_user.present?
      unless FacebookUserFinder.find(oauth)
        AddsAuthentication.new(current_user).add("facebook", uid: oauth.uid)
        unless current_user.guest?
          # if we are logged in and not a guest, we just connected
          # facebook to an existing user and we do not want to
          # process the rest of the action
          @user = current_user
          (render && return) if request.xhr?
          redirect_to registrations_facebook_path
        end
      end
    end

    @user = FacebookUserCreator.from_oauth(oauth)

    if @user.persisted?
      # TODO: background this?
      FacebookProfilePictureUpdater.new(@user, oauth.uid).update!

      sign_in @user, :event => :authentication #this will throw if @user is not activated
      # set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
      session["devise.fb_access_token"] = oauth.access_token
      session["devise.fb_access_token_expiration"] = oauth.access_token_expires_at

      (render && return) if request.xhr?
      redirect_to registrations_facebook_path
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      (render && return) if request.xhr?
      redirect_to new_user_registration_url
    end
  end

  def google
    redirect_to new_user_session_path and return unless current_user.present?
    oauth = OmniauthHashParser.new(request.env["omniauth.auth"])
    AddsAuthentication.new(current_user).from_oauth(oauth)
    redirect_to new_friend_path(anchor: "gmailfriends")
  end
end
