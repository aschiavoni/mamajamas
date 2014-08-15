describe UsernameGenerator, :type => :model do

  context "from email" do

    it "should parse username from email" do
      expect(UsernameGenerator.from_email("user@example.com")).to eq("user")
    end

    it "should append unique number if username is not unique" do
      expect(User).to receive(:find_by_username).with("user").and_return(double)
      expect(User).to receive(:find_by_username).with("user_2").and_return(double)
      expect(User).to receive(:find_by_username).with("user_3").and_return(nil)
      expect(UsernameGenerator.from_email("user@example.com")).to eq("user_3")
    end

    it "returns nil if email is nil" do
      expect(UsernameGenerator.from_email(nil)).to be_nil
    end

    it "returns nil if email is blank" do
      expect(UsernameGenerator.from_email("")).to be_nil
    end

    it "returns email if email is not valid" do
      expect(UsernameGenerator.from_email('test')).to eq('test')
    end

    it "returns email with unique number if email is not valid and not unique" do
      expect(User).to receive(:find_by_username).with('test').and_return(double)
      expect(User).to receive(:find_by_username).with('test_2').and_return(nil)
      expect(UsernameGenerator.from_email('test')).to eq('test_2')
    end

  end

  context "from name" do

    it "returns parameterized name" do
      expect(User).to receive(:find_by_username).with("johndoe").and_return(nil)
      expect(UsernameGenerator.from_name("John Doe")).to eq("johndoe")
    end

    it "handles first names" do
      expect(User).to receive(:find_by_username).with("john").and_return(nil)
      expect(UsernameGenerator.from_name("john")).to eq("john")
    end

    it "should append unique number if username is not unique" do
      expect(User).to receive(:find_by_username).with("johndoe").and_return(double)
      expect(User).to receive(:find_by_username).with("johndoe_2").and_return(double)
      expect(User).to receive(:find_by_username).with("johndoe_3").and_return(nil)
      expect(UsernameGenerator.from_name("John Doe")).to eq("johndoe_3")
    end

    it "returns nil if name is nil" do
      expect(UsernameGenerator.from_name(nil)).to be_nil
    end

    it "returns nil if name is blank" do
      expect(UsernameGenerator.from_name("")).to be_nil
    end

  end

end
