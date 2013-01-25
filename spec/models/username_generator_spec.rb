describe UsernameGenerator do

  it "should parse username from email" do
    UsernameGenerator.from_email("user@example.com").should == "user"
  end

  it "should append unique number if username is not unique" do
    User.should_receive(:find_by_username).with("user").and_return(stub)
    User.should_receive(:find_by_username).with("user_2").and_return(stub)
    User.should_receive(:find_by_username).with("user_3").and_return(nil)
    UsernameGenerator.from_email("user@example.com").should == "user_3"
  end

end
