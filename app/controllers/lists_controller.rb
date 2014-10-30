class ListsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :init_view, only: [ :show ]
  before_filter :find_list, only: [ :show, :product_types,
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
      cat = 'all' if cat.blank? && current_user.sign_in_count > 1
      @view = ListView.new(@list, cat)
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
      template = "wait"
    end

    respond_to do |format|
      format.html { render template }
    end
  end

  def product_types
    @available_product_types = @list.available_product_types(params[:filter], 20)

    respond_to do |format|
      format.html { not_found }
      format.json
    end
  end

  def check
    render json: { complete: ( @list.present? && @list.completed? ) }
  end

  def clear_recommended
    flash[:notice] = "We have cleared all recommended items from your list."
    ListRecommendationService.new(current_user).clear_recommendations!
    redirect_to list_path
  end

  private

  def init_view
    set_subheader "Your baby gear list"
    set_page_id "buildlist"
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
