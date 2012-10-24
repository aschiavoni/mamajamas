module FriendsHelper
  def profile_image(user)
    user.uid.blank? ? user_profile_image(user) : facebook_profile_image(user)
  end

  private

  def user_profile_image(user)
    image_tag("profile_photo.jpg", :alt => user.username)
  end

  def facebook_profile_image(user)
    image_tag(user.facebook.profile_pic_url(user.uid), :alt => user.username)
  end
end
