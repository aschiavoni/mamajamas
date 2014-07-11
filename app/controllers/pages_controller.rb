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

  # TODO: cache page
  def mjsb
    @categories = Category.includes(:product_types).map { |c|
      {
        name: c.name,
        id: c.id,
        product_types: c.product_types.map { |pt|
          { id: pt.id, name: pt.name }
        }
      }
    }.to_json

    render layout: false
  end
end
