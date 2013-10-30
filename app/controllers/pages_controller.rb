class PagesController < ApplicationController
  before_filter :init_view

  def terms
    set_subheader "Privacy Policy & Terms of Service"
  end

  def about
    set_subheader "About Mamajamas"
  end

  private

  def init_view
    set_body_class "text-page"
  end
end
