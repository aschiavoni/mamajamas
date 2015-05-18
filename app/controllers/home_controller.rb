class HomeController < ApplicationController
  before_filter :init_view

  def index
  end

  def error
    raise "Testing Sentry Integration"
  end

  private

  def init_view
    hide_header
    hide_mainnav
    set_body_class "home"
  end
end
