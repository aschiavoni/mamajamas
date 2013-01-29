module FriendsHelper
  def profile_image(user)
    user.uid.blank? ? user_profile_image(user) : facebook_profile_image(user)
  end

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

  private

  def user_profile_image(user)
    image_tag("profile_photo.jpg", :alt => user.username)
  end

  def facebook_profile_image(user)
    image_tag(user.facebook.profile_pic_url, :alt => user.username)
  end
end
