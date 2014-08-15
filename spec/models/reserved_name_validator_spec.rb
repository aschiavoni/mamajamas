describe ReservedNameValidator, :type => :model do

  let(:validator) { ReservedNameValidator.new(attributes: [:name]) }

  let(:model) { double(:errors => double(:add)) }

  it "should validate valid name" do
    expect(model).not_to receive(:errors)
    validator.validate_each(model, "name", "allowedname")
  end

  it "should validate invalid name" do
    expect(model.errors).to receive(:add).with("name", :reserved_name)
    validator.validate_each(model, "name", "user")
  end

end
