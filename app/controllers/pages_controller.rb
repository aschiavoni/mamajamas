class PagesController < ApplicationController
  before_filter :init_view

  def terms
    set_subheader "Terms of Service"
  end

  private

  def init_view
    hide_progress_bar
    set_body_class "text-page"
  end
end

