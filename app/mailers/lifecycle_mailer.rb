class LifecycleMailer < ActionMailer::Base
  include MailerHelper

  layout "mailer"
  default from: "automom@mamajamas.com"

  def post_due_ratings(user_id)
    @user = User.find(user_id)
    @display_name = first_name(@user)
    @subject = "Time to review your baby gear"
    @hide_salutation = true
    mail to: @user.email, subject: @subject
  end

  def baby_shower(user_id)
    @user = User.find(user_id)
    @display_name = first_name(@user)
    @subject = "Your Baby Shower!"
    @hide_salutation = true
    mail to: @user.email, subject: @subject
  end
end
