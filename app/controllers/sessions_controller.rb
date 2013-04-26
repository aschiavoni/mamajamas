class SessionsController < Devise::SessionsController
  before_filter :init_view

  def new
    self.resource = build_resource(nil, :unsafe => true)

    # if we are in the create action, this means the login failed and we are
    # rendering the new view. there may be a better way to do this but this
    # works for now
    if request[:action] == "create"
      self.resource.errors.add(:base, "Invalid login or password.")
    end

    clean_up_passwords(resource)
    (render(:partial => "login", :layout => false) && return) if request.xhr?
    respond_with(resource, serialize_options(resource))
  end

  def create
    self.resource = warden.authenticate!(auth_options)
    set_flash_message(:notice, :signed_in) if is_navigational_format?
    (render(:js => "window.location=\"#{after_sign_in_path_for(resource)}\";") && return) if request.xhr?
    respond_with resource, :location => after_sign_in_path_for(resource)
  end

  private

  def init_view
    set_page_id "user-login"
    set_subheader = "Login"
    set_body_class "form-page"
    hide_header
    hide_progress_bar
  end
end
