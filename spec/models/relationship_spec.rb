require 'spec_helper'

describe Relationship, :type => :model do

  describe "a valid Relationship" do

    let(:follower) { create(:user) }

    let(:followed) { create(:user) }

    let(:relationship) { follower.relationships.build(followed_id: followed.id) }

    it "should be valid" do
      expect(relationship).to be_valid
    end

    it "should respond to follower" do
      expect(relationship).to respond_to(:follower)
    end

    it "should respond to followed" do
      expect(relationship).to respond_to(:follower)
    end

    it "relationship follower should be follower" do
      expect(relationship.follower).to eq(follower)
    end

    it "relationship followed should be followed" do
      expect(relationship.followed).to eq(followed)
    end

  end

  describe "invalid relationships" do

    it "followed_id should be present" do
      relationship = Relationship.new
      relationship.follower_id = 1
      expect(relationship).not_to be_valid
    end

    it "follower_id should be present" do
      relationship = Relationship.new(followed_id: 1)
      expect(relationship).not_to be_valid
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
      expect(@follower.relationships.pending_notification).not_to include(@notified)
    end

    it "should not return relationships that have not already had a notification delivered" do
      expect(@follower.relationships.pending_notification).to include(@not_notified)
    end

  end

end
