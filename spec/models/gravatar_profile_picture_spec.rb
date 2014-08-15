describe GravatarProfilePicture, :type => :model do
  let(:url) { GravatarProfilePicture.url("user@example.com", 48) }

  it "includes gravatar url" do
    expect(url).to match(/^http:\/\/www\.gravatar.com\/avatar\//)
  end

  it "includes gravatar id in the url" do
    expect(url).to match(/b58996c504c5638798eb6b511e6f49af/)
  end

  it "includes size in the url" do
    expect(url).to match(/\?s=48&/)
  end

  it "includes default url" do
    expect(url).to match(/mamajamas/)
  end

end
