describe Forms::CompleteProfile do

  let(:user) { stub.as_null_object }
  let(:test_val) { "test" }

  it "should expose user" do
    Forms::CompleteProfile.new(user).user.should == user
  end

  it "should update delegated user attributes" do
    [ :email, :password ].each do |attribute|
      user.should_receive("#{attribute}=").with(test_val)
    end
    profile = Forms::CompleteProfile.new(user)
    profile.update!(email: test_val, password: test_val)
  end

  it "updates username based on email address" do
    profile = Forms::CompleteProfile.new(User.new)
    UsernameGenerator.should_receive(:from_email).
      with('test99@example.com').
      and_return('test99')

    profile.update!(email: 'test99@example.com', password: test_val)

    profile.user.username.should == 'test99'
  end

  context "user" do

    it "returns nil for a guest email" do
      guest = User.new_guest
      profile = Forms::CompleteProfile.new(guest)
      profile.email.should be_nil
    end

    it "returns real email for for a dirty guest" do
      guest = User.new_guest
      profile = Forms::CompleteProfile.new(guest)
      profile.email = 'test123@example.com'
      profile.email.should == 'test123@example.com'
    end

    it "returns real email for a non-guest user" do
      user = build(:user)
      profile = Forms::CompleteProfile.new(user)
      profile.email.should == user.email
    end

  end
end
