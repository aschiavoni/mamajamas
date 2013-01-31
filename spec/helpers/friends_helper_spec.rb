require 'spec_helper'

describe FriendsHelper do

  describe "display name" do

    it "should show first and last name" do
      user = build(:user, first_name: "John", last_name: "Doe")
      helper.display_name(user).should == "John Doe"
    end


    it "should show user name for user with no names" do
      user = build(:user, username: "johndoe")
      helper.display_name(user).should == "johndoe"
    end

    it "should show user name for user with only first name" do
      user = build(:user, username: "johndoe", first_name: "John")
      helper.display_name(user).should == "johndoe"
    end

    it "should show user name for user with only last name" do
      user = build(:user, username: "johndoe", last_name: "John")
      helper.display_name(user).should == "johndoe"
    end

  end

end
