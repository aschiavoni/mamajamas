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
      relationship.follower_id = create(:user).id
      relationship.should_not be_valid
    end

    it "follower_id should be present" do
      relationship = Relationship.new(followed_id: create(:user).id)
      relationship.should_not be_valid
    end

  end

  describe "security" do

    it "should prevent access to follower_id" do
      expect {
        Relationship.new(follower_id: create(:user).id)
      }.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end

  end

end
