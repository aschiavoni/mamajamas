class InvitationMailer < ActionMailer::Base
  include MailerHelper

  def invitation(invite_id)
    @invite = Invite.find(invite_id)
    @from_name = from_name(@invite)

    @invite.invite_sent_at = Time.now.utc
    @invite.save!

    mail(from: from_address(@invite),
         to: to_address(@invite),
         subject: "Check out Mamajamas.com")
  end

  private

  def from_name(invite)
    invite.from || full_name(invite.user)
  end

  def from_address(invite)
    "#{from_name(invite)} <#{invite.user.email}>"
  end

  def to_address(invite)
    "#{invite.name} <#{invite.email}>"
  end
end
