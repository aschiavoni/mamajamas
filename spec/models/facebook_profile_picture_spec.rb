describe FacebookProfilePicture, :type => :model do

  let(:uid) { "12345" }

  it "should initialize with uid" do
    expect(FacebookProfilePicture.new(uid).uid).to eq(uid)
  end

  it "should raise if passed a nil uid" do
    expect {
      FacebookProfilePicture.new(nil)
    }.to raise_error(FacebookUidNilException)
  end

  it "should expose type" do
    expect(FacebookProfilePicture.new(uid, type: :small).type).to eq(:small)
  end

  it "should expose width" do
    expect(FacebookProfilePicture.new(uid, width: 100).width).to eq(100)
  end

  it "should expose height" do
    expect(FacebookProfilePicture.new(uid, height: 100).height).to eq(100)
  end

  it "should return square url by default" do
    expected = "https://graph.facebook.com/#{uid}/picture?type=square"
    expect(FacebookProfilePicture.new(uid).url).to eq(expected)
  end

  it "should allow customization of picture type" do
    expected = "https://graph.facebook.com/#{uid}/picture?type=small"
    expect(FacebookProfilePicture.new(uid, type: :small).url).to eq(expected)
  end

  it "should only allow certain types" do
    expect {
      FacebookProfilePicture.new(uid, type: :unknown)
    }.to raise_error(FacebookUnknownProfilePictureTypeException)
  end

  it "should default to type if width is specified but not height" do
    expected = "https://graph.facebook.com/#{uid}/picture?type=square"
    expect(FacebookProfilePicture.new(uid, type: :square, width: 100).url).to eq(expected)
  end

  it "should default to type if height is specified but not width" do
    expected = "https://graph.facebook.com/#{uid}/picture?type=square"
    expect(FacebookProfilePicture.new(uid, type: :square, height: 100).url).to eq(expected)
  end

  it "should allow customization of width and height" do
    expected = "https://graph.facebook.com/#{uid}/picture?width=150&height=100"
    expect(FacebookProfilePicture.new(uid, width: 150, height: 100).url).to eq(expected)
  end

end
