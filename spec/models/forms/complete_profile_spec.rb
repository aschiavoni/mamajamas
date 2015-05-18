describe Forms::CompleteProfile, :type => :model do

  let(:user) { double.as_null_object }
  let(:test_val) { "test" }

  it "should expose user" do
    expect(Forms::CompleteProfile.new(user).user).to eq(user)
  end

  it "should update delegated user attributes" do
    [ :email, :password ].each do |attribute|
      expect(user).to receive("#{attribute}=").with(test_val)
    end
    profile = Forms::CompleteProfile.new(user)
    profile.update!(email: test_val, password: test_val)
  end

  it "updates username based on email address" do
    profile = Forms::CompleteProfile.new(User.new)
    expect(UsernameGenerator).to receive(:from_email).
      with('test99@example.com').
      and_return('test99')

    profile.update!(email: 'test99@example.com', password: test_val)

    expect(profile.user.username).to eq('test99')
  end

  context "user" do

    it "returns nil for a guest email" do
      guest = User.new_guest
      profile = Forms::CompleteProfile.new(guest)
      expect(profile.email).to be_nil
    end

    it "returns real email for for a dirty guest" do
      guest = User.new_guest
      profile = Forms::CompleteProfile.new(guest)
      profile.email = 'test123@example.com'
      expect(profile.email).to eq('test123@example.com')
    end

    it "returns real email for a non-guest user" do
      user = build(:user)
      profile = Forms::CompleteProfile.new(user)
      expect(profile.email).to eq(user.email)
    end

  end
end
