class RelationshipMailer < ActionMailer::Base
  default from: "no-reply@mamajamas.com"

  def follower_notification(relationship)
    @followed = relationship.followed
    @follower = relationship.follower
    @followed_display_name = display_name(@followed)
    @follower_display_name = display_name(@follower)

    relationship.delivered_notification_at = Time.zone.now
    relationship.save

    mail(to: "#{@followed_display_name} <#{@followed.email}>",
         subject: "New follower")
  end

  private

  # TODO: this method is a duplicate of one in FriendsHelper, dry this up
  def display_name(user)
    unless user.first_name.blank? || user.last_name.blank?
      "#{user.first_name} #{user.last_name}"
    else
      user.username
    end
  end
end
