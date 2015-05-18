describe UsernameFinder, :type => :model do

  it "returns the requested username when it is not in use" do
    requested = "username"
    expect(UsernameFinder.find(requested)).to eq(requested)
  end

  it "returns the username with a number added when the username is in use" do
    requested = "username"
    allow(User).to receive(:find_by_username).and_return(double, nil)
    expect(UsernameFinder.find(requested)).to eq("#{requested}_1")
  end

  it "increments the number added to username until a unique one is found" do
    requested = "username"
    allow(User).to receive(:find_by_username).and_return(double, double, nil)
    expect(UsernameFinder.find(requested)).to eq("#{requested}_2")
  end

  it "removes invalid characters from returned username" do
    requested = "user.123.name"
    expect(UsernameFinder.find(requested)).to eq("user123name")
  end

  it "converts username to all lowercase characters" do
    requested = "USER12345"
    expect(UsernameFinder.find(requested)).to eq(requested.downcase)
  end

end
