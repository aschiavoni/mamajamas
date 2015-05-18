describe RelationshipBuilder, :type => :model do

  let(:user) { create(:user) }
  let(:builder) { builder = RelationshipBuilder.new(user) }

  it "follows a friend" do
    friend = double
    expect(user).to receive(:follow!).with(friend)
    builder.build_relationships([ friend ])
  end

  it "follows every friend" do
    friends = [ double, double, double ]
    expect(user).to receive(:follow!).exactly(friends.size).times
    builder.build_relationships(friends)
  end

  it "should set relationships created at timestamp" do
    friend = double(:id => 1)
    builder.build_relationships([ friend ])
    expect(user.relationships_created_at).to be_present
  end

end
