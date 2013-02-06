class PublicListsController < ApplicationController
  before_filter :find_public_list
  before_filter :init_view

  def show
    @categories = @list.categories.for_list

    if params[:category].present?
      @category = @categories.by_slug(params[:category]).first
    else
      @category = @categories.first
    end
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
