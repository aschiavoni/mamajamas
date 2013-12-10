class FriendsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :no_guests
  before_filter :init_index_view, only: [ :index ]
  before_filter :init_view, only: [ :following, :followers, :new ]

  def index
    all_fb_friends = current_user.facebook.mamajamas_friends
    @fb_friends = all_fb_friends
    @recommended_friends = RecommendedFriend.new(current_user, all_fb_friends).
      with_pics(6)

    if current_user.relationships_created_at.blank?
      RelationshipBuilder.new(current_user).build_relationships(@fb_friends)
    end
  end

  def following
    @friends = current_user.followed_users.order("follower_count desc")
  end

  def followers
    @friends = current_user.followers.includes(:list).
      where("lists.privacy <> ?", List::PRIVACY_PRIVATE).
      order("follower_count desc")
  end

  def new
    if current_user.google_connected? && current_user.google_friends.empty?
      GoogleContactsWorker.perform_async(current_user.id)
    end
    @view = FindFriendsView.new(current_user)
  end

  def notify
    if params[:notify] == "1"
      current_user.relationships.pending_notification.each do |relationship|
        RelationshipMailer.delay.follower_notification(relationship)
      end
    end
    redirect_to post_notify_redirect_path
  end

  protected

  def init_view
    set_body_id "p-browse"
    set_body_class "layout_2-7-3"
    hide_header
    skip_secondary_content
  end

  def init_index_view
    set_subheader "Follow Friends"
  end

  def post_notify_redirect_path
    if current_user.list.present? && !current_user.list.private?
      path = public_list_path(current_user)
    else
      redirect_path = list_path
    end
  end
end
