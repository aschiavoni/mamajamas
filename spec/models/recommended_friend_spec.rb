describe RecommendedFriend, :type => :model do

  let(:user) { create(:user) }
  let(:list) { create(:list, user: user) }

  before(:all) do
    # unshare all existing lists (this sucks)
    List.all.each do |l|
      l.update_attributes!(privacy: List::PRIVACY_PRIVATE)
    end
    create_list(:list, 4, privacy: List::PRIVACY_PUBLIC)
    @user_with_unshared_list =
      create(:list, privacy: List::PRIVACY_PRIVATE).user
  end

  it "returns all recommended users" do
    rf = RecommendedFriend.new(user)
    expect(rf.all.size).to eq(4)
  end

  it "returns limited number of recommended users" do
    rf = RecommendedFriend.new(user)
    expect(rf.all(3).size).to eq(3)
  end

  it "excludes current user" do
    rf = RecommendedFriend.new(user)
    expect(rf.all).not_to include(user)
  end

  it "excludes user's facebook friends" do
    fb_user = create(:user)
    rf = RecommendedFriend.new(user, [ fb_user ])
    expect(rf.all).not_to include(fb_user)
  end

  it "excludes users without public lists" do
    rf = RecommendedFriend.new(user)
    expect(rf.all).not_to include(@user_with_unshared_list)
  end

end
