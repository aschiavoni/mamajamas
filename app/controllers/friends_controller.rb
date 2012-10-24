class FriendsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @friends = current_user.facebook.mamajamas_friends(5)
    @total_friends = current_user.facebook.mamajamas_friends.size
  end
end
