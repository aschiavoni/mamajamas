# TODO: refactor into concerns
class ApplicationController < ActionController::Base
  protect_from_forgery

  # hide behind basic auth for now
  if Rails.env.production?
    http_basic_authenticate_with :name => "mamajamas", :password => "mamab1rd"
  end

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

  # show a confirmation message if the user is not confirmed and it has
  # been more than 48 hours since they signed up
  def prompt_to_confirm_email_maybe
    if user_signed_in? && !current_user.confirmed?
      if Time.now.utc - User.first.confirmation_sent_at > 48.hours
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
