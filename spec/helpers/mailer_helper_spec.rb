describe MailerHelper do

  describe "full_name" do

    it "returns user full name" do
      user = stub(first_name: "John", last_name: "Doe")
      full_name(user).should == "John Doe"
    end

    it "returns first name if last name not present" do
      user = stub(first_name: "John").as_null_object
      full_name(user).should == "John"
    end

    it "returns username if first name not present" do
      user = stub(username: "jj").as_null_object
      full_name(user).should == "jj"
    end

  end


  describe "first_name" do

    it "returns user first name" do
      user = stub(first_name: "John")
      first_name(user).should == "John"
    end

    it "returns username if first name not present" do
      user = stub(username: "jj").as_null_object
      first_name(user).should == "jj"
    end

  end
end
