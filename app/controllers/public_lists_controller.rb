class PublicListsController < ApplicationController
  before_filter :authenticate_user!, only: [ :copy ]
  before_filter :find_shared_list, only: [ :show ]
  before_filter :pinnable, only: [ :show ]
  before_filter :init_view, except: [ :copy ]

  def show
    @page_title = "Baby Registry: #{@list.user.full_name} - Mamajamas"
    cat = params[:category] || 'all'
    @view = PublicListView.new(@list, cat, false, current_user)

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
    set_subheader @list.title
    set_tertiary_class "light"
    set_page_id "registry"
  end

  def find_shared_list
    owner = User.find(params[:slug])
    @list = owner.list if owner.present?
    not_found unless shareable?(@list)
  end

  private

  def shareable?(list)
    if list.blank? ||
      ((!list.public? && !list.registry?) && current_user != list.user)
      false
    else
      true
    end
  end

  def allowed_user?
    current_user && !current_user.guest?
  end
end
