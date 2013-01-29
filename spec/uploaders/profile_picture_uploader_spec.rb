describe ProfilePictureUploader do
  include CarrierWave::Test::Matchers

  let(:user) { build(:user) }

  let(:uploader) { ProfilePictureUploader.new(user, :profile_picture) }

  let(:profile_picture) do
    File.join(Rails.root,
              'spec',
              'support',
              'profile_pictures',
              'profile_photo-default.png')
  end

  let(:invalid_profile_picture) do
    File.join(Rails.root,
              'spec',
              'support',
              'profile_pictures',
              'profile_photo-default.pdf')
  end

  after do
    uploader.remove!
  end

  it "should upload file" do
    uploader.store!(File.open(profile_picture))
    uploader.length.should > 0
  end

  it "should only accept images" do
    lambda {
      uploader.store!(File.open(invalid_profile_picture))
    }.should raise_error(CarrierWave::IntegrityError)
  end

end
