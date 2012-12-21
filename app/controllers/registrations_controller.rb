class RegistrationsController < Devise::RegistrationsController
  prepend_before_filter :authenticate_scope!, :only => [:edit, :update, :destroy, :facebook, :facebook_update]

  respond_to :json

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
      # (render(:partial => "signup", :layout => false) && return) if request.xhr?
      # respond_with resource
      respond_to do |format|
        format.html
        format.json
      end
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
    resource_sym = resource_name.to_sym
    expires_in = params["expiresIn"].to_i
    params[resource_sym] = {}
    params[resource_sym][:access_token] = params["accessToken"]
    params[resource_sym][:access_token_expires_at] = (Time.now.utc + expires_in.seconds)

    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    render json: { success: self.resource.update_attributes(resource_params) }
  end

  def facebook_friends_update
    params[resource_name.to_sym] = {
      facebook_friends: params.delete(:friends).values,
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
end
