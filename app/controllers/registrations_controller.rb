class RegistrationsController < Devise::RegistrationsController
  prepend_before_filter :authenticate_scope!, :only => [:edit, :update, :destroy, :facebook, :facebook_update]
  prepend_before_filter :logout_guest, only: [ :new ]
  before_filter :init_view, only: [ :new ]

  respond_to :json

  def create
    if params[resource_name.to_sym].blank?
      # create guest user
      @user = User.new_guest
      if @user.persisted?
        sign_in(resource_name, @user)
        redirect_to quiz_path and return
      else
        redirect_to new_user_registration_path
      end
    else
      # create real user
      build_resource

      # manually default guest to false, I only have to do this
      # in the heroku environment, not sure why
      resource.guest = false if resource.respond_to?(:guest)

      # always remember password
      resource.remember_me = true if resource.respond_to?(:remember_me)

      if resource.save
        if resource.active_for_authentication?
          flash_message = :signed_up
          @redirect_path = after_sign_up_path_for(resource)
        else
          flash_message = "signed_up_but_#{resource.inactive_message}"
          @redirect_path = after_inactive_sign_up_path_for(resource)
        end

        resource.send_welcome_email if resource.respond_to?(:send_welcome_email)
        set_flash_message :notice, flash_message if is_navigational_format?
        sign_in(resource_name, resource)
      else
        clean_up_passwords resource
        init_view
      end

      respond_to do |format|
        format.html do
          if defined?(@redirect_path)
            redirect_to @redirect_path
          else
            render 'new' and return
          end
        end
        format.json
      end
    end
  end

  def facebook_update
    expires_in = params["expiresIn"].to_i
    auth = {
      access_token: params["accessToken"],
      access_token_expires_at: (Time.now.utc + expires_in.seconds)
    }
    AddsAuthentication.new(current_user).add("facebook", auth)
    render json: { success: true }
  end

  def facebook_friends_update
    friends = params.delete(:friends)
    params[resource_name.to_sym] = {
      facebook_friends: friends ? friends.values : [],
      facebook_friends_updated_at: Time.now.utc
    }

    current_resource = send(:"current_#{resource_name}")
    if current_resource
      self.resource = resource_class.to_adapter.get!(current_resource.to_key)
    else
      conditions = { uid: params.delete("uid"), provider: "facebook" }
      self.resource = resource_class.to_adapter.find_first(conditions)
    end
    render json: { success: self.resource.update_attributes(resource_params) }
  end

  protected

  def after_sign_up_path_for(resource)
    friends_path
  end

  private

  def init_view
    set_page_id "user-signup"
    set_subheader = "Signup"
    set_body_class "form-page"
    hide_header
    hide_progress_bar
  end
end
