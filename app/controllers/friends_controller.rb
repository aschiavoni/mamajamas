class FriendsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :no_guests
  before_filter :init_view, only: [ :index ]

  def index
    all_fb_friends = current_user.facebook.mamajamas_friends
    @fb_friends = all_fb_friends
    @recommended_friends = RecommendedFriend.new(current_user, all_fb_friends).all(5)

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

  protected

  def init_view
    set_subheader "Follow Friends"
    set_progress_id 2
  end
end
