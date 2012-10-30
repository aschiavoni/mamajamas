require "minitest_helper"

class UserTest < MiniTest::Rails::ActiveSupport::TestCase
  def setup
    @user = nil
  end

  test "should respond to relationships" do
    assert user.respond_to? :relationships
  end

  test "should respond to followed_users" do
    assert user.respond_to? :followed_users
  end

  test "should respond to reverse_relationships" do
    assert user.respond_to? :reverse_relationships
  end

  test "should respond to followers" do
    assert user.respond_to? :followers
  end

  test "should respond to following?" do
    assert user.respond_to? :following?
  end

  test "should respond to follow!" do
    assert user.respond_to? :follow!
  end

  test "should respond to unfollow!" do
    assert user.respond_to? :unfollow!
  end

  test "should follow user" do
    other_user = create(:user)
    user.follow! other_user

    assert user.following? other_user
    assert user.followed_users.include?(other_user)
    assert other_user.followers.include?(user)
  end

  test "should unfollow user" do
    # follow
    other_user = create(:user)
    user.follow! other_user
    assert user.following? other_user

    # unfollow
    user.unfollow! other_user
    refute user.following? other_user
    refute user.followed_users.include?(other_user)
  end

  private

  def user
    @user ||= create(:user)
  end
end
