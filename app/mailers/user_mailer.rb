class UserMailer < ActionMailer::Base
  include MailerHelper

  layout "mailer"
  default from: "\"Angie Schiavoni, Mamajamas\" <angie@mamajamas.com>"

  def welcome(user_id)
    @user = User.find(user_id)
    @display_name = first_name(@user)
    @subject = "Welcome to Mamajamas!"
    mail to: @user.email, bcc: "angie@mamajamas.com", subject: @subject
  end
end
