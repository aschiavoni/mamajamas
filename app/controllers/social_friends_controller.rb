class SocialFriendsController < ApplicationController
  before_filter :authenticate_user!

  def check
    provider = params[:provider]
    social_friends = current_user.social_friends.where(provider: provider)
    render json: { complete: social_friends.any? }
  end
end
