class ConfirmationsController < Devise::ConfirmationsController
  before_filter :init_view

  private

  def init_view
    set_page_id "confirmation-instructions"
    set_subheader = "Resend confirmation instructions"
    set_body_class "form-page"
    hide_header
    hide_progress_bar
  end
end
