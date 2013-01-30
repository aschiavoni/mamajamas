module UsersHelper
  def profile_picture(user_profile)
    if user_profile.profile_picture.present?
      image_tag user_profile.profile_picture, alt: user_profile.username
    else
      image_tag "profile_photo-default-l.png", alt: "Upload a profile photo"
    end
  end
end
