# TODO: refactor into concerns
class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :require_basic_auth_maybe
  before_filter :set_meta

  # Convenience accessor for flash[:error]
  def error
    flash[:error]
  end
  helper_method :error

  # Convenience accessor for flash[:error]=
  def error=(message)
    flash[:error] = message
  end

  # Convenience accessor for flash[:success]
  def success
    flash[:success]
  end
  helper_method :success

  # Convenience accessor for flash[:success]=
  def success=(message)
    flash[:success] = message
  end

  def page_context
    @page_context ||= PageContext.new do
      page_id = nil
      subheader = "Welcome to Mamajamas!"
    end
  end
  helper_method :page_context

  def set_page_id(page_id)
    page_context.page_id = page_id
  end

  def set_body_class(css_class)
    page_context.body_class = css_class
  end

  def set_subheader(subheader)
    page_context.subheader = subheader
  end

  def set_preheader(preheader)
    page_context.preheader = preheader
  end

  def hide_header
    page_context.show_header = false
  end

  def hide_mainnav
    page_context.show_mainnav = false
  end

  protected

  def site_description
    @site_description ||= "With so much on your mind right now, who has time to figure out exactly what you will need for the new baby? Mamajamas offers a super-easy way for you to build a personalized, prioritized list of baby gear."
  end

  def set_meta
    logo = asset_url("logo-m@2x.png")
    set_meta_tags(title: 'Mamajamas',
                  description: site_description,
                  og: {
                    title: "Mamajamas",
                    description: site_description,
                    url: "http://www.mamajamas.com/",
                    image: logo
                  })
  end

  def after_sign_in_path_for(resource)
    list_path
  end

  def allow_guest!
    if current_user.blank?
      @user = User.new_guest
      sign_in(:user, @user) if @user.persisted?
    end
  end

  def logout_guest
    sign_out :user if current_user && current_user.guest?
  end

  # hide behind basic auth for now
  def require_basic_auth_maybe
    if Rails.env.staging?
      authenticate_or_request_with_http_basic do |user, password|
        user == "mamajamas" && password == "mamab1rd"
      end
    end

    if Rails.env.production?
      authenticate_or_request_with_http_basic do |user, password|
        user == "mamajamas" && password == "welcome123"
      end
    end
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  def no_guests
    if current_user.guest?
      respond_to do |format|
        format.html do
          notice_partial = 'shared/guest_not_authorized'
          flash[:notice] = render_to_string(partial: notice_partial).html_safe
          redirect_to profile_path
        end
        format.json do
          render json: { status: :unauthorized }, status: :unauthorized
        end
      end
    end
  end

  def set_cache_buster
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end

  def asset_url(source)
    path = ActionController::Base.helpers.asset_path(source)
    unless Rails.application.config.action_controller.asset_host.present?
      path = "#{request.protocol}#{request.host_with_port}#{path}"
    end
    path
  end
end
