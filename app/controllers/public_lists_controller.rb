class PublicListsController < ApplicationController
  before_filter :authenticate_user!, only: [ :preview, :publish ]
  before_filter :find_list, only: [ :preview, :publish ]
  before_filter :find_shared_list, only: [ :show ]
  before_filter :pinnable, only: [ :show ]
  before_filter :init_view

  def show
    cat = params[:category] || 'all'
    @view = PublicListView.new(@list, cat, false, current_user)
    @view.friends_prompt = cookies.delete(:friends_prompt) == "true"

    # redirect if using an old slug
    if redirect_needed?(@view)
      redirect_to redirect_destination(@view) and return
    end

    @list_entries_json = render_list_entries(@view.list_entries)
    @list.increment_public_view_count

    respond_to do |format|
      format.html do
        if @list.registered_users_only? && !allowed_user?
          render "private"
        else
          render "show"
        end
      end
    end
  end

  def preview
    cat = params[:category] || 'all'
    @view = PublicListView.new(@list, cat, true)
    @list_entries_json = render_list_entries(@view.list_entries)
    render 'show', formats: :html
  end

  def publish
    unless params[:cancel] == '1'
      # only show the friends prompt if it the list is being switched
      # from a private list
      cookies[:friends_prompt] = @list.private?

      @list.update_attributes!(privacy: params[:privacy])
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
    set_tertiary_class "light"
  end

  def find_list
   @list = current_user.list
    not_found if @list.blank?
  end

  def find_shared_list
    owner = User.find(params[:slug])
    @list = owner.list if owner.present?
    not_found unless shareable?(@list)
  end

  private

  def shareable?(list)
    return false if @list.blank? || @list.private?
    return true
  end

  def allowed_user?
    current_user && !current_user.guest?
  end
end
