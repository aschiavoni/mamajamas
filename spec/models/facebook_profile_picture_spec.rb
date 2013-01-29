describe FacebookProfilePicture do

  let(:uid) { "12345" }

  it "should initialize with uid" do
    FacebookProfilePicture.new(uid).uid.should == uid
  end

  it "should expose type" do
    FacebookProfilePicture.new(uid, type: :small).type.should == :small
  end

  it "should expose width" do
    FacebookProfilePicture.new(uid, width: 100).width.should == 100
  end

  it "should expose height" do
    FacebookProfilePicture.new(uid, height: 100).height.should == 100
  end

  it "should return square url by default" do
    expected = "http://graph.facebook.com/#{uid}/picture?type=square"
    FacebookProfilePicture.new(uid).url.should == expected
  end

  it "should allow customization of picture type" do
    expected = "http://graph.facebook.com/#{uid}/picture?type=small"
    FacebookProfilePicture.new(uid, type: :small).url.should == expected
  end

  it "should only allow certain types" do
    lambda {
      FacebookProfilePicture.new(uid, type: :unknown)
    }.should raise_error(UnknownFacebookProfilePictureTypeException)
  end

  it "should default to type if width is specified but not height" do
    expected = "http://graph.facebook.com/#{uid}/picture?type=square"
    FacebookProfilePicture.new(uid, type: :square, width: 100).url.should == expected
  end

  it "should default to type if height is specified but not width" do
    expected = "http://graph.facebook.com/#{uid}/picture?type=square"
    FacebookProfilePicture.new(uid, type: :square, height: 100).url.should == expected
  end

  it "should allow customization of width and height" do
    expected = "http://graph.facebook.com/#{uid}/picture?width=150&height=100"
    FacebookProfilePicture.new(uid, width: 150, height: 100).url.should == expected
  end

end
