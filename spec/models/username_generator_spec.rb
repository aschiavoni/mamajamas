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

  it "returns nil if email is nil" do
    UsernameGenerator.from_email(nil).should be_nil
  end

  it "returns nil if email is blank" do
    UsernameGenerator.from_email("").should be_nil
  end

  it "returns email if email is not valid" do
    UsernameGenerator.from_email('test').should == 'test'
  end

  it "returns email with unique number if email is not valid and not unique" do
    User.should_receive(:find_by_username).with('test').and_return(stub)
    User.should_receive(:find_by_username).with('test_2').and_return(nil)
    UsernameGenerator.from_email('test').should == 'test_2'
  end

end
