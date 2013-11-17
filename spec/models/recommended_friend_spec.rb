describe RecommendedFriend do

  let(:user) { create(:user) }
  let(:list) { create(:list, user: user, public: true) }

  before(:all) do
    # unshare all existing lists (this sucks)
    List.all.each do |l|
      l.update_attributes!(privacy: List::PRIVACY_PRIVATE)
    end
    create_list(:list, 4, public: true)
    @user_with_unshared_list = create(:list, public: false).user
  end

  it "returns all recommended users" do
    rf = RecommendedFriend.new(user)
    rf.all.size.should == 4
  end

  it "returns limited number of recommended users" do
    rf = RecommendedFriend.new(user)
    rf.all(3).size.should == 3
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
    rf = RecommendedFriend.new(user)
    rf.all.should_not include(@user_with_unshared_list)
  end

end
