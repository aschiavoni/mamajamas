class BookmarkletController < ApplicationController
  layout 'bookmarklet'

  before_filter :authenticate_user!, only: [ :create ]
  before_filter :init_view

  def index
    @list_item = ListItem.new(priority: 1)
  end

  def create
    @list = current_user.list
    @list_item = @list.add_list_item(ListItem.new(params[:list_item]))
    if @list.save
      render json: @list_item.attributes.
        merge(view_url: list_category_url(@list_item.category.slug, s: 'ud'))
    else
      render json: { errors: @list_item.errors }
    end
  end

  private

  def init_view
    e = 24.hours
    @categories = Rails.cache.fetch('bookmarklet-categories', expire_in: e) do
      Category.includes(:product_types).order(:name).map { |c|
        {
          name: c.name,
          id: c.id,
          product_types: c.product_types.map { |pt|
            { id: pt.id, name: pt.name }
          }.push(ProductType.find_by_name('Other')).sort { |x, y|
            x[:name] <=> y[:name]
          }
        }
      }
    end

    @categories_json = Rails.cache.fetch('bookmarklet-categories-json',
                                         expire_in: e) do
      @categories.to_json
    end

    @age_ranges = Rails.cache.fetch('bookmarklet-age-ranges', expire_in: e) do
      AgeRange.all
    end
  end
end
