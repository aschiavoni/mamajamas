class PublicListsController < ApplicationController
  before_filter :authenticate_user!, only: [ :preview, :publish ]
  before_filter :find_list, only: [ :preview, :publish ]
  before_filter :find_public_list, only: [ :show ]
  before_filter :init_view

  def show
    cat = params[:category] || 'all'
    @view = PublicListView.new(@list, cat, false, current_user)

    # redirect if using an old slug
    if redirect_needed?(@view)
      redirect_to redirect_destination(@view) and return
    end

    @list_entries_json = render_list_entries(@view.list_entries)
    @list.increment_public_view_count

    if current_user == @list.user
      set_preheader "My Shared List"
    else
      set_preheader "Shared List"
    end

    respond_to do |format|
      format.html
    end
  end

  def preview
    @view = PublicListView.new(@list, params[:category], true)
    @list_entries_json = render_list_entries(@view.list_entries)
    render 'show', formats: :html
  end

  def publish
    if params[:publish] == '1'
      @list.share_public!
      SharedListNotifier.send_shared_list_notification(@list)
      redirect_to public_list_path(current_user.slug)
    else
      redirect_to list_path
    end
  end

  private

  def render_list_entries(list_entries)
    render_to_string(
      template: 'list_items/index',
      formats: :json,
      locals: { list_entries: list_entries })
  end

  def redirect_needed?(list_view)
    paths = [ public_list_path(list_view.owner.slug) ]
    if list_view.category.present?
      paths << public_list_category_path(list_view.owner.slug,
                                         list_view.category.slug)
    end
    !paths.include?(request.path)
  end

  def redirect_destination(list_view)
    if list_view.all_category?
      public_list_path(list_view.owner)
    else
      public_list_category_path(list_view.owner, list_view.category)
    end
  end

  def init_view
    set_page_id "publist"
    set_subheader @list.title
    set_progress_id 3
    hide_progress_bar
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
