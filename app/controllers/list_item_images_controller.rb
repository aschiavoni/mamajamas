class ListItemImagesController < ApplicationController
  before_filter :authenticate_user!
  skip_before_filter :verify_authenticity_token

  def create
    attrs = params[:list_item_image]

    @list_item_image = ListItemImage.create!(attrs) do |list_item_image|
      list_item_image.user_id = current_user.id
    end

    json = render_to_string(
      template: 'list_item_images/create',
      formats: :json)

    render text: json, content_type: "text/plain"
  end
end
