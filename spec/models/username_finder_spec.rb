describe UsernameFinder do

  it "returns the requested username when it is not in use" do
    requested = "username"
    UsernameFinder.find(requested).should == requested
  end

  it "returns the username with a number added when the username is in use" do
    requested = "username"
    User.stub(:find_by_username).and_return(stub, nil)
    UsernameFinder.find(requested).should == "#{requested}1"
  end

  it "increments the number added to username until a unique one is found" do
    requested = "username"
    User.stub(:find_by_username).and_return(stub, stub, nil)
    UsernameFinder.find(requested).should == "#{requested}2"
  end

  it "removes invalid characters from returned username" do
    requested = "user.123.name"
    UsernameFinder.find(requested).should == "user123name"
  end

  it "converts username to all lowercase characters" do
    requested = "USER12345"
    UsernameFinder.find(requested).should == requested.downcase
  end

end
