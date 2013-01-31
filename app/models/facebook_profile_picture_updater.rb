class FacebookProfilePictureUpdater
  def initialize(user, profile_picture_class = FacebookProfilePicture)
    @user = user
    @profile_picture_class = profile_picture_class
  end

  def update!
    if user.profile_picture.blank?
      user.profile_picture.download!(large_profile_picture.url)
      user.save!
    end
  end

  private

  def large_profile_picture
    @profile_picture ||= @profile_picture_class.new(@user.uid, type: :large)
  end

  def user
    @user
  end
end
