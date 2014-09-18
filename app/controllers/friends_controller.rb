class FriendsController < ApplicationController
  before_filter :authenticate_user!, except: [ :new ]
  before_filter :no_guests, except: [ :new ]
  before_filter :init_index_view, only: [ :index ]
  before_filter :init_view, only: [ :following, :followers, :new, :browse ]
  before_filter only: [:new] { |c|
    c.set_facebook_ad_conversion_params '6014528521078'
  }

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
    @view = FriendsListView.new(current_user, params[:sort])
  end

  def followers
    @view = FriendsListView.new(current_user, params[:sort])
  end

  def new
    if current_user.present? && !current_user.guest?
      if current_user.google_connected? && current_user.google_friends.empty?
        GoogleContactsWorker.perform_async(current_user.id)
      end
    end
    @view = FindFriendsView.new(current_user, params[:sort])
  end

  def notify
    if params[:notify] == "1"
      current_user.relationships.pending_notification.each do |relationship|
        unless relationship.followed.new_follower_notifications_disabled?
          RelationshipMailer.delay.follower_notification(relationship)
        end
      end
    end
    redirect_to post_notify_redirect_path
  end

  protected

  def init_view
    set_body_id "p-browse"
    hide_header
  end

  def init_index_view
    set_subheader "Follow Friends"
  end

  def post_notify_redirect_path
    if current_user.list.present? && !current_user.list.private?
      public_list_path(current_user)
    else
      cookies.delete(:after_sign_in_path) || list_path
    end
  end
end
