class GiftsController < ApplicationController
  before_filter :init_view
  before_filter :find_list_item

  respond_to :html, :json

  def new
    @ship_to_me = params[:shipto] == "me"
    @ship_to_none = params[:shipto] == "none"
    @gift = Gift.new(list_item: @list_item)
  end

  def preview
    @gift = Gift.new(list_item: @list_item)
  end

  def create
    gift_params = params[:gift]
    gift_params[:user_id] = current_user.id if current_user.present?
    @gift = @list_item.gift_item(params[:gift])
    if @gift.persisted?
      respond_to do |format|
        format.html do
          redirect_to public_list_category_path(@owner, @list_item.category.slug)
        end
        format.json do
          render json: @gift
        end
      end
    else
      respond_to do |format|
        format.html do
          render :new
        end
        format.json do
          raise "Could not save gift"
        end
      end
    end
  end

  def update
    @gift = @list_item.gifts.find_by_id(params[:gift_id])
    if @gift.present?
      @gift.update_attributes!(params[:gift])
    else
      @gift = @list_item.gift_item(params[:gift])
    end

    unless @gift.purchased?
      @list_item.desired_quantity = @list_item.desired_quantity + @gift.quantity
      @list_item.owned_quantity = @list_item.owned_quantity - @gift.quantity
      @list_item.save!
    end

    if params[:notify] == "true"
      GiftNotificationWorker.perform_async(@gift.id)
    end

    respond_to do |format|
      format.html do
        redirect_to public_list_category_path(@owner, @list_item.category.slug)
      end
      format.json do
        respond_with @gift
      end
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
