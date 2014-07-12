class BookmarkletController < ApplicationController
  layout 'bookmarklet'

  before_filter :authenticate_user!, only: [ :create ]
  before_filter :init_view

  # TODO: cache page
  def index
    @list_item = ListItem.new(priority: 2)
  end

  def create
    @list = current_user.list
    @list_item = @list.add_list_item(ListItem.new(params[:list_item]))
    unless @list.save
      fixable_errors = [ :name, :price, :notes ]
      if (@list_item.errors.keys & fixable_errors).any?
        render 'index'
      end
    end
  end

  private

  def init_view
    @categories = Category.includes(:product_types).map { |c|
      {
        name: c.name,
        id: c.id,
        product_types: c.product_types.map { |pt|
          { id: pt.id, name: pt.name }
        }
      }
    }

    @categories_json = @categories.to_json

    @age_ranges = AgeRange.all
  end
end
