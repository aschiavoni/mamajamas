class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :prompt_to_confirm_email_maybe

  protected

  def prompt_to_confirm_email_maybe
    if user_signed_in? && !current_user.confirmed?
      # this may get overwritten at times but that should be ok
      flash[:notice] = render_to_string(partial: "shared/confirmation_instructions").html_safe
    end
  end
end
