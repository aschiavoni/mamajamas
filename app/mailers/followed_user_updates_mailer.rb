class FollowedUserUpdatesMailer < ActionMailer::Base
  include MailerHelper

  layout "mailer"
  default from: "automom@mamajamas.com"

  def daily_digest(user_id)
    @user = User.find(user_id)
    return if @user.followed_user_updates_disabled?

    since = @user.followed_user_updates_sent_at || 1.day.ago

    @updates = FollowedUserUpdates.new(@user).updates_since(since, 5)
    return if @updates.size <= 0

    @user.update_attributes!({ followed_user_updates_sent_at: Time.now.utc },
                             { without_protection: true })

    sig = EmailAccessToken.
      create_access_token(@user, "followed_user_updates")
    @unsub_url = unsubscribe_url(signature: sig)

    @hide_salutation = true
    @display_name = first_name(@user)
    @first_followed = first_name(@updates.first.first)
    @subject = "New gear has been added to #{@first_followed.possessive} list!"
    mail to: @user.email, subject: @subject
  end
end