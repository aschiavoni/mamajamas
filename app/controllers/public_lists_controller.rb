class PublicListsController < ApplicationController
  before_filter :authenticate_user!, only: [ :preview, :publish ]
  before_filter :find_list, only: [ :preview, :publish ]
  before_filter :find_public_list, only: [ :show ]
  before_filter :init_view

  def show
    # redirect if using an old slug
    if request.path != public_list_path(@list.user.slug)
      redirect_to public_list_path(@list.user.slug), status: :moved_permanently
    end

    @view = PublicListView.new(@list, params[:category])
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

  def init_view
    @page_id = "publist"
    @subheader = @list.title
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
