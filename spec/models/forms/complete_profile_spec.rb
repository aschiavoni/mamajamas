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

end
