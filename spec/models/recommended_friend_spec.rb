describe RecommendedFriend do

  let(:user) { create(:user) }
  let(:list) { create(:list, user: user, public: true) }

  before(:all) do
    create_list(:list, 4, public: true)
  end

  it "returns all recommended users" do
    rf = RecommendedFriend.new(user)
    rf.all.size.should == 4
  end

  it "returns limited number of recommended users" do
    rf = RecommendedFriend.new(user)
    rf.all(3).size.should == 4
  end

  it "excludes current user" do
    rf = RecommendedFriend.new(user)
    rf.all.should_not include(user)
  end

  it "excludes user's facebook friends" do
    fb_user = create(:user)
    rf = RecommendedFriend.new(user, [ fb_user ])
    rf.all.should_not include(fb_user)
  end

  it "excludes users without public lists" do
    new_user = create(:list, public: false).user
    rf = RecommendedFriend.new(user)
    rf.all.should_not include(new_user)
  end

end
