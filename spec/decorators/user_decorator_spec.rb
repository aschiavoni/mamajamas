# coding: utf-8
require 'spec_helper'

describe UserDecorator do

  let(:user) { build(:user).extend UserDecorator }

  subject { user }

  it { should be_a User }

  describe "display name" do

    it "should show first and last name" do
      user.first_name = "John"
      user.last_name = "Doe"
      user.display_name.should == "John Doe"
    end


    it "should show user name for user with no names" do
      user.username = "johndoe"
      user.display_name.should == "johndoe"
    end

    it "should show user name for user with only first name" do
      user.username = "johndoe"
      user.first_name = "John"
      user.display_name.should == "johndoe"
    end

    it "should show user name for user with only last name" do
      user.username = "johndoe"
      user.last_name = "Doe"
      user.display_name.should == "johndoe"
    end

  end

  describe "display first name or username" do

    it "should display first name if not blank" do
      user.first_name = "Joe"
      user.display_first_name_or_username.should == "Joe"
    end

    it "should display username if first name is blank" do
      user.username = "johndoe"
      user.display_first_name_or_username.should == "johndoe"
    end

  end

  describe "display last name" do

    it "should display last name" do
      user.last_name = "Doe"
      user.display_last_name == "Doe"
    end

    it "should return nothing if last name is blank" do
      user.display_last_name.should be_blank
    end

  end

  describe "followed users with public lists" do

    it "should return only followed users who have public lists" do
      user.save!

      user1 = create(:list).user
      user2 = create(:list, privacy: List::PRIVACY_PUBLIC).user
      user3 = create(:list).user

      user.follow!(user1)
      user.follow!(user2)
      user.follow!(user3)

      user.followed_users_with_shared_lists.should == [ user2 ]
    end

  end

end
