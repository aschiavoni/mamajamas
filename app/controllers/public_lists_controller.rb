class PublicListsController < ApplicationController
  before_filter :authenticate_user!, only: [ :preview, :publish ]
  before_filter :find_list, only: [ :preview, :publish ]
  before_filter :find_public_list, only: [ :show ]
  before_filter :init_view

  def show
    @view = PublicListView.new(@list, params[:category])

    # redirect if using an old slug
    if redirect_needed?(@view)
      redirect_to redirect_destination(@view) and return
    end

    @list_entries_json = render_to_string(
      template: 'list_items/index',
      formats: :json,
      locals: { list_entries: @view.list_entries })

    hide_progress_bar

    respond_to do |format|
      format.html
    end
  end

  def preview
    @view = PublicListView.new(@list, params[:category], true)
    render 'show'
  end

  def publish
    if params[:publish] == '1'
      @list.make_public!
      redirect_to public_list_path(current_user.slug)
    else
      redirect_to list_path
    end
  end

  private

  def redirect_needed?(list_view)
    ![
      public_list_path(list_view.owner.slug),
      public_list_category_path(list_view.owner.slug, list_view.category.slug)
    ].include?(request.path)
  end

  def redirect_destination(list_view)
    if list_view.default_category?
      public_list_path(list_view.owner)
    else
      public_list_category_path(list_view.owner, list_view.category)
    end
  end

  def init_view
    set_page_id "publist"
    set_subheader @list.title
    set_progress_id 3
  end

  def find_list
   @list = current_user.list
    not_found if @list.blank?
  end

  def find_public_list
    owner = User.find(params[:slug])
    @list = owner.list if owner.present?
    not_found if @list.blank? || !@list.public?
  end
end
