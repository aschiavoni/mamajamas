class RelationshipMailer < ActionMailer::Base
  include MailerHelper

  layout "mailer"
  default from: "automom@mamajamas.com"

  def follower_notification(relationship_id)
    relationship = Relationship.find(relationship_id)
    @followed = relationship.followed

    return if @followed.new_follower_notifications_disabled?

    @follower = relationship.follower
    @display_name = @followed_display_name = full_name(@followed)
    @follower_display_name = full_name(@follower)

    relationship.delivered_notification_at = Time.zone.now
    relationship.save!

    @subject = "Someone is following you!"
    @hide_salutation = true

    sig = EmailAccessToken.
      create_access_token(@followed, "new_follower_notifications")
    @unsub_url = unsubscribe_url(signature: sig)

    mail(to: "#{@followed_display_name} <#{@followed.email}>",
         subject: @subject)
  end
end
