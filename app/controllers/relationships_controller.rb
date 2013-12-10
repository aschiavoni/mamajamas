class RelationshipsController < ApplicationController
  before_filter :authenticate_user!

  respond_to :json

  def create
    @friend = User.find(params[:relationship][:followed_id])
    relationship = current_user.following?(@friend)
    relationship = current_user.follow!(@friend) if relationship.blank?

    if params[:no_notification].blank? && relationship.delivered_notification_at.blank?
      RelationshipMailer.delay.follower_notification(relationship.id)
    end

    respond_to do |format|
      format.html do
        render(partial: partial_to_render,
               locals: { friend: @friend, following: relationship })
      end
      format.json do
        render json: { relationship_id: relationship.id }
      end
    end
  end

  def destroy
    @friend = Relationship.find(params[:id]).followed
    current_user.unfollow!(@friend)
    render(partial: partial_to_render,
           locals: {
             friend: @friend,
             following: current_user.following?(@friend)
           })
  end

  private

  def partial_to_render
    partial_to_render = "friends/friend"
    if params[:follow_friend] == "1"
      partial_to_render = "friends/follow_friend"
    end
    partial_to_render
  end
end
