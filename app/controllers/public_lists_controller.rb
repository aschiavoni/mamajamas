class PublicListsController < ApplicationController
  before_filter :find_public_list

  def show
  end

  private

  def find_public_list
    owner = User.find_by_username(params[:username])
    @list = owner.list if owner.present?
    not_found if @list.blank? || !@list.public?
  end
end
