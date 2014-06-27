class PagesController < ApplicationController
  def terms
    set_body_class "layout_2-7-3"
    set_subheader "Privacy Policy & Terms of Service"
  end

  def privacy
    set_body_class "layout_2-7-3"
    set_subheader "Privacy Policy & Terms of Service"
  end

  def about
    set_body_class "text-page"
    set_subheader "About Mamajamas"
  end

  def faq
    set_body_class "text-page"
    set_subheader "Frequently Asked Questions"
  end

  def mjsb
    render layout: false
  end
end
