class FriendsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :no_guests
  before_filter :init_view, only: [ :index, :new ]

  def index
    @friends = current_user.followed_users
  end

  def new
  end

  def notify
    if params[:notify] == "1"
      current_user.relationships.pending_notification.each do |relationship|
        RelationshipMailer.delay.follower_notification(relationship)
      end
    end
    redirect_to list_path
  end

  protected

  def init_view
    set_body_class "layout_2-7-3"
    set_subheader "My Friends' Lists"
    hide_progress_bar
  end
end
