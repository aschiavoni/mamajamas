class GiftsController < ApplicationController
  before_filter :init_view
  before_filter :find_list_item

  def new
    @gift = Gift.new(list_item: @list_item)
  end

  def create
    gift_params = params[:gift]
    gift_params[:user_id] = current_user.id if current_user.present?
    @gift = @list_item.gift_item(params[:gift])
    if @gift.persisted?
      redirect_to public_list_category_path(@owner, @list_item.category.slug)
     else
       render :new
    end
  end

  private

  def init_view
    hide_header
    set_body_class "bgfill"
    set_nested_window
  end

  def find_list_item
    @list_item = ListItem.find(params[:list_item_id])
    @owner = @list_item.list.user
    @owner.class.send(:include, UserDecorator)
  end
end
