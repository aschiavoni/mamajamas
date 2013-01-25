describe UserProfileUpdater do

  it "should update user attributes" do
    user_params = { name: "test" }
    user = stub
    user.should_receive(:update_attributes).with(user_params)
    UserProfileUpdater.new(user).update(user_params, {})
  end

  it "should update list attributes" do
    list_params = { name: "test" }
    user = stub(:update_attributes => true, :list => stub)
    user.list.should_receive(:update_attributes).with(list_params)
    UserProfileUpdater.new(user).update({}, list_params)
  end

  it "should format birthday" do
    birthday = "01/06/2008"
    user_params = { "birthday" => birthday }
    user = stub.as_null_object
    Date.should_receive(:strptime).with(birthday, "%m/%d/%Y")
    UserProfileUpdater.new(user).update(user_params, {})
  end

end
