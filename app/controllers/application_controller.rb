class ApplicationController < ActionController::Base
  protect_from_forgery

  # hide behind basic auth for now
  unless Rails.env.development?
    http_basic_authenticate_with :name => "mamajamas", :password => "mamab1rd"
  end

  before_filter :prompt_to_confirm_email_maybe

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
end
