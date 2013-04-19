class HomeController < ApplicationController
  before_filter :init_view

  def index
  end

  private

  def init_view
    hide_header
    hide_progress_bar
    set_body_class "home"
  end
end
