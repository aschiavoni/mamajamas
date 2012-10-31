class RelationshipsController < ApplicationController
  before_filter :authenticate_user!

  def create
    @friend = User.find(params[:relationship][:followed_id])
    current_user.follow!(@friend)
    render(partial: 'friends/friend', locals: { friend: @friend, following: current_user.following?(@friend) })
  end

  def destroy
    @friend = Relationship.find(params[:id]).followed
    current_user.unfollow!(@friend)
    render(partial: 'friends/friend', locals: { friend: @friend, following: current_user.following?(@friend) })
  end
end
