require "minitest_helper"

class RelationshipTest < MiniTest::Rails::ActiveSupport::TestCase
  def setup
    @follower = nil
    @followed = nil
    @relationship = nil
  end

  test "relationship should be valid" do
    assert relationship.valid?
  end

  test "should prevent access to follower_id" do
    assert_raises ActiveModel::MassAssignmentSecurity::Error do
      Relationship.new(follower_id: follower.id)
    end
  end

  test "should respond to follower" do
    assert relationship.respond_to? :follower
  end

  test "should respond to followed" do
    assert relationship.respond_to? :followed
  end

  test "relationship follower should be follower" do
    assert_equal follower, relationship.follower
  end

  test "relationship followed should be followed" do
    assert_equal followed, relationship.followed
  end

  test "followed_id should be present" do
    relationship.followed_id = nil
    refute relationship.valid?
  end

  test "follower_id should be present" do
    relationship.follower_id = nil
    refute relationship.valid?
  end

  private

  def follower
    @follower ||= create(:user)
  end

  def followed
    @followed ||= create(:user)
  end

  def relationship
    @relationship ||= follower.relationships.build(followed_id: followed.id)
  end
end
