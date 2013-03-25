require 'spec_helper'

describe ListItemImageUploader do
  include CarrierWave::Test::Matchers

  before do
    ListItemImageUploader.enable_processing = true
    ListItemImageUploader.storage = CarrierWave::Storage::File
  end

  after do
    ListItemImageUploader.enable_processing = false
    uploader.remove!
  end

  let(:user) { create(:user) }

  let(:uploader) { ListItemImageUploader.new(user, :list_item_image) }

  let(:list_item_image) do
    File.join(Rails.root,
              'spec',
              'support',
              'list_item_images',
              'hat.png')
  end

  let(:invalid_list_item_image) do
    File.join(Rails.root,
              'spec',
              'support',
              'list_item_images',
              'hat.pdf')
  end

  it "should upload file" do
    uploader.store!(File.open(list_item_image))
    uploader.length.should > 0
  end

  it "should only accept images" do
    lambda {
      uploader.store!(File.open(invalid_list_item_image))
    }.should raise_error(CarrierWave::IntegrityError)
  end

  context "the thumb version" do

    it "should scale the thumb image to 60 by 60 pixels" do
      uploader.store!(File.open(list_item_image))
      uploader.thumb.should be_no_larger_than(60, 60)
    end

  end

end

