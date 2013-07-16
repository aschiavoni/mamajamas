class UserMailer < ActionMailer::Base
  default from: "no-reply@mamajamas.com"

  def welcome(user_id)
    @user = User.find(user_id)
    @display_name = display_name(@user)
    mail to: @user.email
  end

  private

  # TODO: make this a helper or a decorator
  def display_name(user)
    if user.first_name.present?
      user.first_name
    else
      user.username
    end
  end
end
