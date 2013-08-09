class SharedListMailer < ActionMailer::Base
  include MailerHelper

  default from: "automom@mamajamas.com"

  def shared(user_id)
    @user = User.find(user_id)
    @display_name = first_name(@user)

    mail to: @user.email,
      bcc: "angie@mamajamas.com",
      subject: "Your Shared Mamajamas List"
  end
end
