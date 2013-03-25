class ListItemImagesController < ApplicationController
  before_filter :authenticate_user!

  respond_to :json

  def create
    attrs = params[:list_item_image]

    @list_item_image = ListItemImage.create!(attrs) do |list_item_image|
      list_item_image.user_id = current_user.id
    end

    respond_with @list_item_image
  end
end
