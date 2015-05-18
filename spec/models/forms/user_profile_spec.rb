describe Forms::UserProfile, :type => :model do

  let(:user) { double.as_null_object }
  let(:list) { double.as_null_object }
  let(:test_val) { "test" }

  subject { Forms::UserProfile }

  it "should expose user" do
    expect(subject.new(user, list).user).to eq(user)
  end

  it "should expose list" do
    expect(subject.new(user, list).list).to eq(list)
  end

  it "should update delegated user attributes" do
    [ :username, :first_name ].each do |attribute|
      expect(user).to receive("#{attribute}=").with(test_val)
    end
    profile = subject.new(user, list)
    profile.update!(username: test_val, first_name: test_val)
  end

  it "should update delegated list attributes" do
    [ :title ].each do |attribute|
      expect(list).to receive("#{attribute}=").with(test_val)
    end
    profile = subject.new(user, list)
    profile.update!(list_title: test_val)
  end

  it "should return list url" do
    user = double(:username => "TestUser", :slug => "testuser")
    expect(subject.new(user, double).list_url).to eq("testuser")
  end

  it "should return formatted birthday" do
    user = double(:birthday => Date.new(1987, 6, 12))
    expect(subject.new(user, double).formatted_birthday).to eq(I18n.l(Date.new(1987, 6, 12)))
  end

  it "should return nil for formatted birthday if not set" do
    user = double(:birthday => nil)
    expect(subject.new(user, double).formatted_birthday).to be_nil
  end

  it "should convert formatted birthday into a valid date" do
    new_birthday = "01/08/2008"
    profile = subject.new(user, double)
    expect(Date).to receive(:strptime).with(new_birthday,
                                        I18n.t("date.formats.default"))
    profile.birthday = new_birthday
  end

  it "should pass through birthday date unchanged" do
    new_birthday = Date.new(2008, 1, 8)
    profile = subject.new(user, double)
    expect(user).to receive(:birthday=).with(new_birthday)
    profile.birthday = new_birthday
  end
end
