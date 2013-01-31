module FriendsHelper
  def display_name(user)
    unless user.first_name.blank? || user.last_name.blank?
      "#{user.first_name} #{user.last_name}"
    else
      user.username
    end
  end

  def display_first_name_or_username(user)
    content_tag :span, class: "firstname" do
      user.first_name || user.username
    end
  end

  def display_last_name(user)
    user.last_name
  end
end
