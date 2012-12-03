require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the FriendsHelper. For example:
#
# describe FriendsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe FriendsHelper do

  describe "profile image" do

    let(:user) { create(:user) }
    let(:facebook_user) { create(:user, uid: "12345") }

    describe "mamajamas user" do

      it "should return local profile photo" do
        helper.profile_image(user).should =~ /profile_photo\.jpg/
      end

    end

    describe "facebook user" do

      it "should return facebook profile photo" do
        helper.profile_image(facebook_user).should =~ /graph\.facebook\.com\/#{facebook_user.uid}\/picture\?type=square/
      end

    end

  end

  describe "display name" do

    it "should show first and last name" do
      user = create(:user, first_name: "John", last_name: "Doe")
      helper.display_name(user).should == "John Doe"
    end


    it "should show user name for user with no names" do
      user = create(:user, username: "johndoe")
      helper.display_name(user).should == "johndoe"
    end

    it "should show user name for user with only first name" do
      user = create(:user, username: "johndoe", first_name: "John")
      helper.display_name(user).should == "johndoe"
    end

    it "should show user name for user with only last name" do
      user = create(:user, username: "johndoe", last_name: "John")
      helper.display_name(user).should == "johndoe"
    end

  end

end
