class SharedListMailer < ActionMailer::Base
  include MailerHelper

  layout "mailer"
  default from: "automom@mamajamas.com"

  def shared(user_id)
    @user = User.find(user_id)
    @display_name = first_name(@user)
    @subject = "Your List is Saved!"
    @hide_salutation = true

    mail to: @user.email,
      bcc: "angie@mamajamas.com",
      subject: @subject
  end
end
