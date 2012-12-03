require 'spec_helper'

describe User do

  let(:user) { create(:user) }

  describe "relationships" do

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

end