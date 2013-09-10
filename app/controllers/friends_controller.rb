class FriendsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :no_guests
  before_filter :init_view, only: [ :index, :new ]

  def index
    @friends = current_user.followed_users
  end

  def new
    @view = FindFriendsView.new(current_user)
  end

  protected

  def init_view
    set_body_class "layout_2-7-3"
    set_subheader "My Friends' Lists"
    hide_progress_bar
  end
end
