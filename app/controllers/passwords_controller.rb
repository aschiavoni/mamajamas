class PasswordsController < Devise::PasswordsController
  before_filter :init_view

  def edit
    self.resource = resource_class.find_or_initialize_with_error_by(:reset_password_token, params[:reset_password_token])
  end

  def update
    self.resource = resource_class.reset_password_by_token(resource_params)
    update_username(self.resource)

    if resource.errors.empty?
      flash_message = resource.active_for_authentication? ? :updated : :updated_not_active
      set_flash_message(:notice, flash_message) if is_navigational_format?
      sign_in(resource_name, resource)
      respond_with resource, :location => after_sign_in_path_for(resource)
    else
      respond_with resource
    end
  end

  protected

  def after_sending_reset_password_instructions_path_for(resource_name)
    root_path
  end

  private

  def update_username(resource)
    unless params[:user][:username].blank?
      if resource.username != params[:user][:username]
        resource.update_attributes!(username: params[:user][:username])
      end
    end
  end

  def init_view
    set_page_id "forgot-password"
    set_subheader = "Forgot your password?"
    set_body_class "form-page"
    hide_header
  end
end
