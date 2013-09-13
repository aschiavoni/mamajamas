class InvitesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :no_guests

  respond_to :json

  def create
    invite_params = params[:invite].merge(user_id: current_user.id)
    if invite_params[:provider] == "facebook"
      invite_params.merge!(invite_sent_at: Time.now.utc)
    end
    @invite = Invite.create(invite_params)
    respond_with @invite
  end
end
