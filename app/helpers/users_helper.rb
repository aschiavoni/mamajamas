module UsersHelper
  def birthday_value(user)
    user.birthday.present? ? l(user.birthday) : nil
  end
end
