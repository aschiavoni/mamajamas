describe RecommendedFriend do

  let(:user) { create(:user) }

  it "should return recommended users" do
    create_list(:user, 3)
    rf = RecommendedFriend.new(user)
    rf.all(3).size.should == 3
  end

  it "should exclude current user" do
    rf = RecommendedFriend.new(user)
    rf.all.should_not include(user)
  end

  it "should exclude user's facebook friends" do
    fb_user = create(:user)
    rf = RecommendedFriend.new(user, [ fb_user ])
    rf.all.should_not include(fb_user)
  end

end
