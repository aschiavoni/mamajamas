class ListsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :init_view, only: [ :show ]
  before_filter :find_list, only: [ :show, :update, :product_types,
                                    :check, :clear_recommended ]
  before_filter :set_cache_buster, only: [ :show ]
  before_filter :set_add_to_list, only: [ :show ]
  before_filter only: [:show] { |c|
    c.set_facebook_ad_conversion_params '6014528473678'
  }

  respond_to :html, :json

  def show
    if current_user.quiz_taken_at.blank?
      redirect_to quiz_path and return
    end

    if @list.present? && @list.completed?
      template = "show"
      cat = params[:category]
      cat = 'all' if cat.blank? && @list.view_count >= 1
      @view = ListView.new(@list, cat, current_user)
      @list_entries_json = Rails.cache.fetch [@list, cat, 'entries'] do
        render_to_string(
          template: 'list_items/index',
          formats: :json,
          locals: { list_entries: @view.list_entries })
      end
      @list.increment_view_count

      if !current_user.guest? &&
          !current_user.show_bookmarklet_prompt? &&
          current_user.show_friends_prompt?
        @view.friends_prompt = true
        current_user.update_attributes!(show_friends_prompt: false)
      end
    else
      set_page_id ""
      hide_header
      template = "wait"
    end

    respond_to do |format|
      format.html { render template }
    end
  end

  def update
    if params[:list].has_key?(:notes)
      @current_user.update_attributes(notes: params[:list].delete(:notes))
    end

    @list.update_attributes(params[:list])

    respond_with @list
  end

  def product_types
    @available_product_types = @list.available_product_types(params[:filter], 20)

    respond_to do |format|
      format.html { not_found }
      format.json
    end
  end

  def check
    if @list.present?
      render json: {
                    id: @list.id,
                    complete: @list.completed?
                   }
    else
      render json: { complete: false, id: nil }
    end
  end

  def clear_recommended
    category_id = params[:category_id]

    if category_id.present?
      category = Category.find(category_id)
      msg = "We have cleared all recommended items from the #{category.name} category."
      redirect_path = list_category_path(category)
    else
      category = nil
      msg = "We have cleared all recommended items from your registry."
      redirect_path = list_path
    end

    ListRecommendationService.
      new(current_user, category).
      clear_recommendations!

    flash[:notice] = msg

    redirect_to redirect_path
  end

  private

  def init_view
    set_page_id "registry"
  end

  def find_list
    @list = current_user.list
  end

  def set_add_to_list
    list_item_id = cookies[:add_to_my_list]
    if list_item_id.present?
      @list.touch # we want to bust the cache at this point
      add_list_item = @list.clone_list_item(list_item_id)
      @add_list_item_json = add_list_item.to_json(methods: [ :age ])
    end
  end
end
