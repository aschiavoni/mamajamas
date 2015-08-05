describe UsernameGenerator, :type => :model do

  context "from email" do

    it "should parse username from email" do
      expect(UsernameGenerator.from_email("someuser@example.com")).to eq("someuser")
    end

    it "should append unique number if username is not unique" do
      expect(User).to receive(:find_by_username).with("someuser").and_return(double)
      expect(User).to receive(:find_by_username).with("someuser_2").and_return(double)
      expect(User).to receive(:find_by_username).with("someuser_3").and_return(nil)
      expect(UsernameGenerator.from_email("someuser@example.com")).to eq("someuser_3")
    end

    it "returns nil if email is nil" do
      expect(UsernameGenerator.from_email(nil)).to be_nil
    end

    it "returns nil if email is blank" do
      expect(UsernameGenerator.from_email("")).to be_nil
    end

    it "returns email if email is not valid" do
      expect(UsernameGenerator.from_email('bademail')).to eq('bademail')
    end

    it "returns email with unique number if email is not valid and not unique" do
      expect(User).to receive(:find_by_username).with('someemail').and_return(double)
      expect(User).to receive(:find_by_username).with('someemail_2').and_return(nil)
      expect(UsernameGenerator.from_email('someemail')).to eq('someemail_2')
    end

  end

  context "from name" do

    it "returns parameterized name" do
      expect(User).to receive(:find_by_username).with("doe").and_return(double)
      expect(User).to receive(:find_by_username).with("johndoe").and_return(nil)
      expect(UsernameGenerator.from_name("John Doe")).to eq("johndoe")
    end

    it "handles first names" do
      expect(User).to receive(:find_by_username).with("john").and_return(nil)
      expect(UsernameGenerator.from_name("john")).to eq("john")
    end

    it "uses last name only if last name available" do
      expect(User).to receive(:find_by_username).with("doe").and_return(nil).twice
      expect(UsernameGenerator.from_name("John Doe")).to eq("doe")
    end

    it "uses full name if last name is not available" do
      expect(User).to receive(:find_by_username).with("doe").and_return(double)
      expect(User).to receive(:find_by_username).with("johndoe").and_return(nil)
      expect(UsernameGenerator.from_name("John Doe")).to eq("johndoe")
    end

    it "should append unique number if username is not unique" do
      expect(User).to receive(:find_by_username).with("doe").and_return(double)
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
