describe RelationshipBuilder do

  let(:user) { create(:user) }
  let(:builder) { builder = RelationshipBuilder.new(user) }

  it "follows a friend" do
    friend = stub
    user.should_receive(:follow!).with(friend)
    builder.build_relationships([ friend ])
  end

  it "follows every friend" do
    friends = [ stub, stub, stub ]
    user.should_receive(:follow!).exactly(friends.size).times
    builder.build_relationships(friends)
  end

end
