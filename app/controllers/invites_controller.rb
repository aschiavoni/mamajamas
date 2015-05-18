class InvitesController < ApplicationController
  respond_to :json

  def create
    if params[:invite][:provider] != 'mamajamas_share' && current_user.blank?
      return head(:forbidden)
    end

    invite_params = params[:invite].merge(user_id: current_user.try(:id))

    if invite_params[:provider] == "facebook"
      invite_params.merge!(invite_sent_at: Time.now.utc)
    end

    if invite_params[:provider] == "mamajamas_share"
      if invite_params
        if invite_params[:name].blank?
          invite_params[:name] = invite_params[:from]
        end
      end
    end

    @invite = Invite.create(invite_params)

    if @invite.persisted?
      if invite_params[:provider] == 'mamajamas_share'
        InvitationMailer.delay.shared_list(@invite.id)
      elsif invite_params[:provider] != "facebook"
        InvitationMailer.delay.invitation(@invite.id)
      end
    end

    respond_with @invite
  end
end
