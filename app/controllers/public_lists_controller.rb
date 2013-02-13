class PublicListsController < ApplicationController
  before_filter :find_public_list
  before_filter :init_view

  def show
    @view = PublicListView.new(@list, params[:category])
  end

  private

  def init_view
    @page_id = "publist"
    @subheader = @list.title
  end

  def find_public_list
    owner = User.find_by_username(params[:username])
    @list = owner.list if owner.present?
    not_found if @list.blank? || !@list.public?
  end
end
