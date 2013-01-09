class FriendsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @subheader = "Follow Mom Friends"
    @fb_friends = current_user.facebook.mamajamas_friends(5)
    @total_fb_friends = current_user.facebook.mamajamas_friends.size
    @recommended_friends = RecommendedFriend.new(current_user).all(5)

    if current_user.relationships_created_at.blank?
      RelationshipBuilder.new(current_user).build_relationships(@fb_friends)
    end
  end

  def notify
    if params[:notify] == "1"
      current_user.relationships.pending_notification.each do |relationship|
        RelationshipMailer.follower_notification(relationship).deliver
      end
    end
    flash[:notice] = "Thanks for signing up with Mamajamas. Now build your list!"
    redirect_to list_path
  end
end
