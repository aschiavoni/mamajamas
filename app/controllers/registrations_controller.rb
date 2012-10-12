class RegistrationsController < Devise::RegistrationsController
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
end
