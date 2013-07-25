class RelationshipsController < ApplicationController
  before_filter :authenticate_user!

  respond_to :json

  def create
    @friend = User.find(params[:relationship][:followed_id])
    relationship = current_user.following?(@friend)
    relationship = current_user.follow!(@friend) if relationship.blank?

    respond_to do |format|
      format.html do
        render(partial: 'friends/friend', locals: { friend: @friend, following: relationship })
      end
      format.json do
        render json: { relationship_id: relationship.id }
      end
    end
  end

  def destroy
    @friend = Relationship.find(params[:id]).followed
    current_user.unfollow!(@friend)
    render(partial: 'friends/friend', locals: { friend: @friend, following: current_user.following?(@friend) })
  end
end
