require 'spec_helper'

describe Relationship do

  describe "a valid Relationship" do

    let(:follower) { create(:user) }

    let(:followed) { create(:user) }

    let(:relationship) { follower.relationships.build(followed_id: followed.id) }

    it "should be valid" do
      relationship.should be_valid
    end

    it "should respond to follower" do
      relationship.should respond_to(:follower)
    end

    it "should respond to followed" do
      relationship.should respond_to(:follower)
    end

    it "relationship follower should be follower" do
      relationship.follower.should == follower
    end

    it "relationship followed should be followed" do
      relationship.followed.should == followed
    end

  end

  describe "invalid relationships" do

    it "followed_id should be present" do
      relationship = Relationship.new
      relationship.follower_id = 1
      relationship.should_not be_valid
    end

    it "follower_id should be present" do
      relationship = Relationship.new(followed_id: 1)
      relationship.should_not be_valid
    end

  end

  describe "security" do

    it "should prevent access to follower_id" do
      expect {
        Relationship.new(follower_id: 1)
      }.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end

  end

  describe "pending notifications" do

    before(:all) do
      @follower = create(:user)

      @notified = @follower.relationships.create!(followed_id: 1)
      @notified.delivered_notification_at = 3.days.ago
      @notified.save!

      @not_notified = @follower.relationships.create!(followed_id: 2)
    end

    it "should not return relationships that have already had a notification delivered" do
      @follower.relationships.pending_notification.should_not include(@notified)
    end

    it "should not return relationships that have not already had a notification delivered" do
      @follower.relationships.pending_notification.should include(@not_notified)
    end

  end

end
