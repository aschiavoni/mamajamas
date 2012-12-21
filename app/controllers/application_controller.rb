# TODO: refactor into concerns
class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :require_basic_auth_maybe
  before_filter :prompt_to_confirm_email_maybe

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

  protected

  def after_sign_in_path_for(resource)
    list_path
  end

  # hide behind basic auth for now
  def require_basic_auth_maybe
    if Rails.env.production?
      authenticate_or_request_with_http_basic do |user, password|
        user == "mamajamas" && password == "mamab1rd"
      end
    end
  end

  # show a confirmation message if the user is not confirmed and it has
  # been more than 48 hours since they signed up
  def prompt_to_confirm_email_maybe
    if user_signed_in? && !current_user.confirmed?
      if Time.now.utc - current_user.confirmation_sent_at > 48.hours
        if flash[:notice].blank?
          flash[:notice] = render_to_string(partial: "shared/confirmation_instructions").html_safe
        end
      end
    end
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end
end
