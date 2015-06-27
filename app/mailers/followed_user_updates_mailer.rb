class FollowedUserUpdatesMailer < ActionMailer::Base
  include MailerHelper

  layout "mailer"
  default from: "automom@mamajamas.com"

  # probably don't want to background this since it takes hydrated
  # objects
  def notify(user_id, followed, added)
    @user = User.find(user_id)
    return if @user.followed_user_updates_disabled?

    sig = EmailAccessToken.
      create_access_token(@user, "followed_user_updates")
    @unsub_url = unsubscribe_url(signature: sig)

    @hide_salutation = true
    @display_name = first_name(@user)
    @followed = followed
    @updates = added
    @subject =
      "New gear has been added to #{first_name(@followed).possessive} Registry!"
    mail to: @user.email, subject: @subject
  end
end
