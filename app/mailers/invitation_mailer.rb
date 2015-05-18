class InvitationMailer < ActionMailer::Base
  include MailerHelper

  layout "mailer"

  def invitation(invite_id)
    @invite = Invite.find(invite_id)
    @display_name = @invite.name
    @from_name = from_name(@invite)

    @invite.invite_sent_at = Time.now.utc
    @invite.save!
    @hide_salutation = true

    mail(from: from_address(@invite),
         to: to_address(@invite),
         subject: "Check out Mamajamas.com")
  end

  def shared_list(invite_id)
    @invite = Invite.find(invite_id)
    @user = @invite.user
    @list = @invite.list

    return if @list.blank?

    @owner = @list.user
    @owned = @user.present? && @user.id == @list.user_id
    default_subject = "Check out this baby registry at Mamajamas.com"
    default_subject = "Check out my baby registry at Mamajamas.com" if @owned

    @subject = @invite.subject || default_subject
    @display_name = @invite.from || @invite.name
    @from_name = from_name(@invite)

    @invite.invite_sent_at = Time.now.utc
    @invite.save!

    @hide_salutation = true

    mail(from: from_address(@invite),
         to: to_address(@invite),
         subject: @subject)
  end

  private

  def from_name(invite)
    invite.from || invite.name || full_name(invite.user)
  end

  def from_address(invite)
    if invite.user.blank?
      from_email = "info@mamajamas.com"
    else
      from_email = invite.user.email
    end
    "#{from_name(invite)} <#{from_email}>"
  end

  def to_address(invite)
    "#{invite.name} <#{invite.email}>"
  end
end
