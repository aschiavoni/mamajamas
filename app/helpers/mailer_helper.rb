module MailerHelper
  def full_name(user)
    if user.first_name.present? && user.last_name.present?
      "#{user.first_name} #{user.last_name}"
    else
      first_name(user)
    end
  end

  def first_name(user)
    if user.first_name.present?
      user.first_name
    else
      user.username
    end
  end
end
