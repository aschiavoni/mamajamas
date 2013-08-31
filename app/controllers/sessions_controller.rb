class SessionsController < Devise::SessionsController
  before_filter :init_view
  skip_filter :prompt_to_confirm_email_maybe, only: [ :create ]
  prepend_before_filter :logout_guest, only: [ :new ]

  def new
    self.resource = build_resource(nil, :unsafe => true)

    # if we are in the create action, this means the login failed and we are
    # rendering the new view. there may be a better way to do this but this
    # works for now
    if request[:action] == "create"
      self.resource.errors.add(:base, "Invalid login or password.")
    end

    clean_up_passwords(resource)
    (render("new", :formats => [:json], :layout => false) && return) if request.xhr?

    respond_with(resource, serialize_options(resource))
  end

  def create
    self.resource = warden.authenticate!(auth_options)
    delete_guest_user_id if guest_user_id.present?
    set_flash_message(:notice, :signed_in) if is_navigational_format?
    (render(:js => "window.location=\"#{after_sign_in_path_for(resource)}\";") && return) if request.xhr?
    respond_with resource, :location => after_sign_in_path_for(resource)
  end

  protected

  # mostly copied from devise_controller
  def require_no_authentication
    assert_is_devise_resource!
    return unless is_navigational_format?
    no_input = devise_mapping.no_input_strategies

    authenticated = if no_input.present?
      args = no_input.dup.push :scope => resource_name
      warden.authenticate?(*args)
    else
      warden.authenticated?(resource_name)
    end

    # afaict, the only way to auth as a different user in the same request,
    # you have to sign out first
    # Since I don't want to sign out the guest user unless they provided
    # valid credentials, I have to manually check the credentials
    if authenticated && resource = warden.user(resource_name)
      if current_user.guest? && sessions_create?
        # validate login/pw manually, if it succeeds, it will be checked again
        # by devise, which is not ideal, hopefully this is not a common use
        # case
        login_params = params[resource_name]
        login = login_params[:login] if login_params.present?
        user = User.find_first_by_auth_conditions(login: login)

        if user.present? && user.valid_password?(login_params[:password])
          sign_out resource_name
        else
          self.resource = User.new login: login
          self.resource.errors.add(:base, I18n.t("devise.failure.invalid"))
          (render("new", :formats => [:json], :layout => false) && return) if request.xhr?
          render partial: 'login', layout: false and return
        end
        return
      end

      flash[:alert] = I18n.t("devise.failure.already_authenticated")
      redirect_to after_sign_in_path_for(resource)
    end
  end

  def sessions_create?
    params[:controller] == 'sessions' && params[:action] == 'create'
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
