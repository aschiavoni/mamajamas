require 'spec_helper'

describe User do

  let(:user) { create(:user) }

  describe "slugs" do

    it "should have slugged value" do
      new_user = create(:user)
      new_user.slug.should == new_user.username
    end

    it "should update slug when username changes" do
      new_user = create(:user)
      new_user.update_attributes!(username: "testxxx1199")
      new_user.slug.should == "testxxx1199"
    end
  end

  describe "facebook connected" do

    it "should be facebook connected" do
      user.update_attributes!(provider: "facebook", uid: 12345)
      user.should be_facebook_connected
    end

    it "should not be facebook connected" do
      user.should_not be_facebook_connected
    end

  end

  describe "relationships" do

    describe "created at" do

      it "return true if relationships have been created" do
        user.relationships_created_at = Time.now.utc
        user.save!

        user.auto_created_relationships?.should be_true
      end

      it "return false if relationships have been created" do
        user.auto_created_relationships?.should be_false
      end

    end

    describe "follow user" do

      let(:other_user) { create(:user) }

      before(:each) do
        user.follow! other_user
      end

      it "should be following other user" do
        user.should be_following(other_user)
      end

      it "should include other user in followed users list" do
        user.followed_users.should include(other_user)
      end

      it "should be in other user's followers list" do
        other_user.followers.should include(user)
      end

      describe "unfollow other user" do

        before(:each) do
          user.unfollow! other_user
        end

        it "should not be following other user" do
          user.should_not be_following(other_user)
        end

        it "should not include other user in followed users list" do
          user.followed_users.should_not include(other_user)
        end

      end

    end

    it "should respond to relationships" do
      user.should respond_to :relationships
    end

    it "should respond to followed_users" do
      user.should respond_to :followed_users
    end

    it "should respond to reverse_relationships" do
      user.should respond_to :reverse_relationships
    end

    it "should respond to followers" do
      user.should respond_to :followers
    end

    it "should respond to following?" do
      user.should respond_to :following?
    end

    it "should respond to follow!" do
      user.should respond_to :follow!
    end

    it "should respond to unfollow!" do
      user.should respond_to :unfollow!
    end

  end

  describe "age" do

    it "should return nil if no birthday specified" do
      user.birthday = nil
      user.age.should be_nil
    end

    it "should return a user's age" do
      now = Date.new(2013, 2, 7)
      user.birthday = Date.new(1977, 5, 11)
      user.age(now).should == 35
    end

  end

  describe "email" do

    it "displays user's email address" do
      user.display_email.should == user.email
    end

    it "displays 'Guest' for email address for guest users" do
      User.new_guest.display_email.should == 'Guest'
    end

  end

  describe "guest users" do

    it "creates a new valid guest user" do
      User.new_guest.should be_valid
    end

    it "creates a guest user" do
      User.new_guest.should be_guest
    end

    it "saves guest user to the database" do
      lambda {
        User.new_guest
      }.should change(User, :count).by(1)
    end

  end

  describe "add facebook uid to an existing user" do

    let(:uid) { '1234554321' }

    it "adds facebook info to a guest user" do
      user.add_facebook_uid!(uid)
      user.uid.should == uid
    end

    it "adds facebook provider to a guest user" do
      user.add_facebook_uid!(uid)
      user.provider.should == 'facebook'
    end

  end

  describe "zip codes" do

    it "validates a correct us zip code" do
      u = build(:user, zip_code: '11201', country_code: 'US')
      u.should be_valid
    end

    it "validates an incorrect us zip code" do
      u = build(:user, zip_code: 'sl41eg', country_code: 'US')
      u.should_not be_valid
    end

    it "validates a correct uk zip code" do
      u = build(:user, zip_code: 'sl41eg', country_code: 'GB')
      u.should be_valid
    end

    it "validates an incorrect uk zip code" do
      u = build(:user, zip_code: '11201', country_code: 'GB')
      u.should_not be_valid
    end

    it "doesn't care about zip code validations in other countries" do
      u = build(:user, zip_code: '11201', country_code: 'BB')
      u.should be_valid
    end

  end

  describe "country" do

    it "validates a correct country code" do
      u = build(:user, country_code: 'US')
      u.should be_valid
    end

    it "validates an incorrect country code" do
      u = build(:user, country_code: 'UU')
      u.should_not be_valid
    end

    it "returns a country name from a country code" do
      user.country_code = 'US'
      user.country_name.should == 'United States'
    end

    it "returns nil if the country code is unknown" do
      user.country_code = "UU"
      user.country_name.should be_nil
    end

  end

end
