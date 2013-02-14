describe Forms::UserProfile do

  let(:user) { stub.as_null_object }
  let(:list) { stub.as_null_object }
  let(:test_val) { "test" }

  subject { Forms::UserProfile }

  it "should expose user" do
    subject.new(user, list).user.should == user
  end

  it "should expose list" do
    subject.new(user, list).list.should == list
  end

  it "should update delegated user attributes" do
    [ :username, :first_name ].each do |attribute|
      user.should_receive("#{attribute}=").with(test_val)
    end
    profile = subject.new(user, list)
    profile.update!(username: test_val, first_name: test_val)
  end

  it "should update delegated list attributes" do
    [ :title ].each do |attribute|
      list.should_receive("#{attribute}=").with(test_val)
    end
    profile = subject.new(user, list)
    profile.update!(list_title: test_val)
  end

  it "should return list url" do
    user = stub(:username => "TestUser", :slug => "testuser")
    subject.new(user, stub).list_url.should == "testuser"
  end

  it "should return formatted birthday" do
    user = stub(:birthday => Date.new(1987, 6, 12))
    subject.new(user, stub).formatted_birthday.should == I18n.l(Date.new(1987, 6, 12))
  end

  it "should return nil for formatted birthday if not set" do
    user = stub(:birthday => nil)
    subject.new(user, stub).formatted_birthday.should be_nil
  end

  it "should convert formatted birthday into a valid date" do
    new_birthday = "01/08/2008"
    profile = subject.new(user, stub)
    Date.should_receive(:strptime).with(new_birthday,
                                        I18n.t("date.formats.default"))
    profile.birthday = new_birthday
  end

  it "should pass through birthday date unchanged" do
    new_birthday = Date.new(2008, 1, 8)
    profile = subject.new(user, stub)
    user.should_receive(:birthday=).with(new_birthday)
    profile.birthday = new_birthday
  end
end
