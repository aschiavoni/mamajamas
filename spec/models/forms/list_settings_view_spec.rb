describe Forms::ListSettingsView do

  let(:user) { stub.as_null_object }
  let(:test_val) { 0 }

  subject { Forms::ListSettingsView }

  it "updates delegated list attributes" do
    [ :privacy ].each do |attribute|
      user.should_receive("#{attribute}=").with(test_val)
    end
    view = subject.new(user)
    view.update!(privacy: test_val)
  end

end
