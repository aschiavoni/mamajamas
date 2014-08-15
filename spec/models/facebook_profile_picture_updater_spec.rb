describe FacebookProfilePictureUpdater do

  it "should update facebook profile picture if it does not exist" do
    uploader = double("profile_picture_uploader", blank?: true)
    uid = "12345"
    user = double("user", profile_picture: uploader)
    updater = FacebookProfilePictureUpdater.new(user, uid)

    user.should_receive(:save!)
    uploader.should_receive(:download!)

    updater.update!
  end

  it "should not update facebook profile picture if it does exist" do
    uploader = double("profile_picture_uploader", blank?: false)
    user = double("user", :profile_picture => uploader)
    updater = FacebookProfilePictureUpdater.new(user, "12345")

    user.should_not_receive(:save!)

    updater.update!
  end

end
