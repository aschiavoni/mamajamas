describe MailerHelper, :type => :helper do

  describe "full_name" do

    it "returns user full name" do
      user = double(first_name: "John", last_name: "Doe")
      expect(full_name(user)).to eq("John Doe")
    end

    it "returns first name if last name not present" do
      user = double(first_name: "John").as_null_object
      expect(full_name(user)).to eq("John")
    end

    it "returns username if first name not present" do
      user = double(username: "jj").as_null_object
      expect(full_name(user)).to eq("jj")
    end

  end


  describe "first_name" do

    it "returns user first name" do
      user = double(first_name: "John")
      expect(first_name(user)).to eq("John")
    end

    it "returns username if first name not present" do
      user = double(username: "jj").as_null_object
      expect(first_name(user)).to eq("jj")
    end

  end
end
