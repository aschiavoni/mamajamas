class UserMailer < ActionMailer::Base
  include MailerHelper

  default from: "\"Angie Schiavoni, Founder\" <angie@mamajamas.com>"

  def welcome(user_id)
    @user = User.find(user_id)
    @display_name = first_name(@user)
    mail to: @user.email, bcc: "angie@mamajamas.com"
  end
end
