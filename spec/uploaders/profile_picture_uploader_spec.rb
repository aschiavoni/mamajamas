require 'spec_helper'

describe ProfilePictureUploader do
  include CarrierWave::Test::Matchers

  before do
    ProfilePictureUploader.enable_processing = true
    ProfilePictureUploader.storage = CarrierWave::Storage::File
  end

  after do
    ProfilePictureUploader.enable_processing = false
    uploader.remove!
  end

  let(:user) { create(:user) }

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

  it "should upload file" do
    uploader.store!(File.open(profile_picture))
    uploader.length.should > 0
  end

  it "should only accept images" do
    lambda {
      uploader.store!(File.open(invalid_profile_picture))
    }.should raise_error(CarrierWave::IntegrityError)
  end

  context "the account version" do

    it "should scale the account image to 24 by 24 pixels" do
      uploader.store!(File.open(profile_picture))
      uploader.account.should be_no_larger_than(24, 24)
    end

    it "should scale the profile image to 142 by 142 pixels" do
      uploader.store!(File.open(profile_picture))
      uploader.account.should be_no_larger_than(142, 142)
    end

    it "should scale the friend image to 84 by 84 pixels" do
      uploader.store!(File.open(profile_picture))
      uploader.account.should be_no_larger_than(84, 84)
    end

  end

end
