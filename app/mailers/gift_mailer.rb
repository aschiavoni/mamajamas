class GiftMailer < ActionMailer::Base
  include MailerHelper

  layout "mailer"
  default from: "automom@mamajamas.com"

  def gift_received(gift_id)
    @gift = Gift.find(gift_id)
    @list_item = @gift.list_item
    return if @list_item.blank?
    @user = @list_item.list.user

    @display_name = first_name(@user)
    @subject = "Someone has sent you a gift!"
    @hide_salutation = true
    mail to: @user.email, subject: @subject
  end
end
