describe Forms::RegistrySettings, :type => :model do

  let(:user) { double.as_null_object }
  let(:list) { double.as_null_object }
  let(:address) { double.as_null_object }
  let(:test_val) { "test" }

  subject { Forms::RegistrySettings }

  it "should expose user" do
    expect(subject.new(user, list).user).to eq(user)
  end

  it "should expose list" do
    expect(subject.new(user, list).list).to eq(list)
  end

  it "should expose address" do
    expect(subject.new(user, list).address).to_not be_nil
  end

  it "should update delegated user attributes" do
    [ :full_name, :partner_full_name ].each do |attribute|
      expect(user).to receive("#{attribute}=").with(test_val)
    end
    registry = subject.new(user, list)
    registry.update!(full_name: test_val, partner_full_name: test_val)
  end

  it "should update delegated list attributes" do
    [ :registry ].each do |attribute|
      expect(list).to receive("#{attribute}=").with(true)
    end
    registry = subject.new(user, list)
    registry.update!(registry: true)
  end

  it "should update delegated address attributes" do
    user.stub(:address) { address }
    [ :street, :street2, :city, :region,
     :postal_code, :country_code, :phone ].each do |attribute|
      expect(address).to receive("#{attribute}=").with(test_val)
    end
    registry = subject.new(user, list)
    registry.update!(street: test_val, street2: test_val, city: test_val,
                     region: test_val, postal_code: test_val,
                     country_code: test_val, phone: test_val)
  end
end
