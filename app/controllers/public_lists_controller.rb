class PublicListsController < ApplicationController
  before_filter :authenticate_user!, only: [ :preview, :publish, :copy ]
  before_filter :find_list, only: [ :preview, :publish ]
  before_filter :find_shared_list, only: [ :show ]
  before_filter :pinnable, only: [ :show ]
  before_filter :init_view, except: [ :copy ]

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

      @list.update_attributes!(saved: true, privacy: params[:privacy])

      unless @list.private?
        SharedListNotifier.send_shared_list_notification(@list)
      end

      redirect_to public_list_path(current_user.slug)
    else
      redirect_to list_path
    end
  end

  def copy
    source_id = params[:source]
    not_found and return if source_id.blank?

    source = List.find(source_id)
    not_found and return unless shareable?(source)

    copier = ListCopier.new source, current_user.list
    copier.copy

    source_user = source.user
    source_user.class.send(:include, UserDecorator)
    flash[:notice] =
      "You have successfully copied #{source_user.possessive_name} List!"

    render json: current_user.list.id
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
    if list_view.all_category? || list_view.category.blank?
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
    @list = List.includes(:user).find_by(users: { slug: params[:slug] })
    not_found unless shareable?(@list)
  end

  private

  def shareable?(list)
    if list.blank? || (list.private? && current_user != list.user)
      false
    else
      true
    end
  end

  def allowed_user?
    current_user && !current_user.guest?
  end
end
