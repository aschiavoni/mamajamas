describe FacebookProfilePictureUpdater, :type => :model do

  it "should update facebook profile picture if it does not exist" do
    uploader = double("profile_picture_uploader", blank?: true)
    uid = "12345"
    user = double("user", profile_picture: uploader)
    updater = FacebookProfilePictureUpdater.new(user, uid)

    expect(user).to receive(:save!)
    expect(uploader).to receive(:download!)

    updater.update!
  end

  it "should not update facebook profile picture if it does exist" do
    uploader = double("profile_picture_uploader", blank?: false)
    user = double("user", :profile_picture => uploader)
    updater = FacebookProfilePictureUpdater.new(user, "12345")

    expect(user).not_to receive(:save!)

    updater.update!
  end

end
