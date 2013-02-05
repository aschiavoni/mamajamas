describe FacebookProfilePictureUpdater do

  it "should update facebook profile picture if it does not exist" do
    uploader = stub(:blank? => true)
    user = stub(:uid => "12345", :profile_picture => uploader)
    updater = FacebookProfilePictureUpdater.new(user)

    user.should_receive(:save!)
    uploader.should_receive(:download!)

    updater.update!
  end

  it "should not update facebook profile picture if it does exist" do
    uploader = stub(:blank? => false)
    user = stub(:profile_picture => uploader)
    updater = FacebookProfilePictureUpdater.new(user)

    user.should_not_receive(:save!)

    updater.update!
  end

end