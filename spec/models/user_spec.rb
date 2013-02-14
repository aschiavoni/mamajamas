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

end
