class FriendsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @subheader = "Follow Mom Friends"
    @fb_friends = current_user.facebook.mamajamas_friends(5)
    @total_fb_friends = current_user.facebook.mamajamas_friends.size
    @recommended_friends = RecommendedFriend.new(current_user).all(5)
  end
end
