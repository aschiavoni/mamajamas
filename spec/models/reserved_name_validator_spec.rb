describe ReservedNameValidator do

  let(:validator) { ReservedNameValidator.new(attributes: {}) }

  let(:model) { stub(:errors => stub(:add)) }

  it "should validate valid name" do
    model.should_not_receive(:errors)
    validator.validate_each(model, "name", "allowedname")
  end

  it "should validate invalid name" do
    model.errors.should_receive(:add).with("name", :reserved_name)
    validator.validate_each(model, "name", "user")
  end

end
