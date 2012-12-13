class FriendsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @subheader = "Follow Mom Friends"
    @fb_friends = current_user.facebook.mamajamas_friends(5)
    @total_fb_friends = current_user.facebook.mamajamas_friends.size
    @recommended_friends = RecommendedFriend.new(current_user).all(5)
  end

  def notify
    if params[:notify] == "1"
      current_user.relationships.pending_notification.each do |relationship|
        RelationshipMailer.follower_notification(relationship).deliver
      end
    end
    redirect_to list_path
  end
end
