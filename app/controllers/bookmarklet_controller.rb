class BookmarkletController < ApplicationController
  # TODO: cache page
  def index
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
