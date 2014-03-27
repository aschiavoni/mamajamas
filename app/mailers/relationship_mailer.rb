class RelationshipMailer < ActionMailer::Base
  include MailerHelper

  layout "mailer"
  default from: "automom@mamajamas.com"

  def follower_notification(relationship_id)
    relationship = Relationship.find(relationship_id)
    @followed = relationship.followed
    @follower = relationship.follower
    @display_name = @followed_display_name = full_name(@followed)
    @follower_display_name = full_name(@follower)

    relationship.delivered_notification_at = Time.zone.now
    relationship.save!

    @subject = "#{@follower_display_name} is now following your Mamajamas List!"

    mail(to: "#{@followed_display_name} <#{@followed.email}>",
         subject: @subject)
  end
end
