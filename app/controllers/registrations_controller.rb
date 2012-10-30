class RegistrationsController < Devise::RegistrationsController
  prepend_before_filter :authenticate_scope!, :only => [:edit, :update, :destroy, :facebook, :facebook_update]

  def create
    build_resource

    if resource.save
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_navigational_format?
        sign_in(resource_name, resource)
        (render(:js => "window.location=\"#{after_sign_up_path_for(resource)}\";") && return) if request.xhr?
        respond_with resource, :location => after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
        #expire_session_data_after_sign_in!
        # go ahead ans sign in right away, use has a grace period for confirmation
        sign_in(resource_name, resource)
        (render(:js => "window.location=\"#{after_inactive_sign_up_path_for(resource)}\";") && return) if request.xhr?
        respond_with resource, :location => after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      (render(:partial => "email_signup_form", :layout => false) && return) if request.xhr?
      respond_with resource
    end
  end

  def facebook
    if request.put?
      self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
      if self.resource.update_attributes(resource_params)
        # Sign in the user bypassing validation in case the password changed
        sign_in self.resource, :bypass => true
        redirect_to friends_path
      else
        render "facebook"
      end
    end
  end

  def facebook_update
    # massage facebook params into user params
    expires_in = params["expiresIn"].to_i
    params[:user] = {}
    params[:user][:access_token] = params["accessToken"]
    params[:user][:access_token_expires_at] = (Time.now.utc + expires_in.seconds)

    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    render json: { success: self.resource.update_attributes(resource_params) }
  end
end
