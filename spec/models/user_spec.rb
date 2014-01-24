require 'spec_helper'

describe User do

  let(:user) { create(:user, quiz_taken_at: nil) }

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

  describe "set username" do

    it "sets a username from email if name not provided" do
      new_user = create(:user, email: "jackdoe@example.com", username: nil)
      new_user.username.should == "jackdoe"
    end

    it "sets a username from full name" do
      new_user = create(:user,
                        first_name: "Jonathan", last_name: "Doe", username: nil)
      new_user.username.should == "jonathandoe"
    end

    it "sets a username from first name" do
      new_user = create(:user,
                        first_name: "Jane", last_name: nil, username: nil)
      new_user.username.should == "jane"
    end

    it "fails to create user if a username cannot be generated" do
      lambda {
        new_user = create(:user,
                          first_name: nil, last_name: nil,
                          username: nil, email: nil)
      }.should raise_error(ActiveRecord::RecordInvalid)
    end

    it "downcases usernames" do
      new_user = create(:user, username: "JackDoe")
      new_user.username.should == "jackdoe"
    end

  end

  describe "facebook connected" do

    it "should be facebook connected" do
      create(:authentication, user: user, provider: "facebook")
      user.should be_facebook_connected
    end

    it "should not be facebook connected" do
      user.clear_facebook!
      user.should_not be_facebook_connected
    end

  end

  describe "google connected" do

    it "is connected to google" do
      create(:authentication, user: user, provider: "google")
      user.should be_google_connected
    end

    it "is not connected to google" do
      user.clear_google!
      user.should_not be_google_connected
    end

    it "has expired google access token" do
      user.clear_google!
      create(:authentication, user: user,
             provider: "google", access_token_expires_at: 2.days.ago)
      user.should_not be_google_connected
    end

    it "returns empty array when user does not have google friends" do
      user.clear_google!
      user.google_friends.should be_empty
    end

    it "retrieves google friends" do
      create(:authentication, user: user, provider: "google")
      create(:social_friends, user: user,
             provider: "google", friends: [ { id: 10 } ])
      user.google_friends.should_not be_empty
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

  describe "email" do

    it "displays user's email address" do
      user.display_email.should == user.email
    end

    it "displays 'Guest' for email address for guest users" do
      User.new_guest.display_email.should == 'Guest'
    end

  end

  describe "guest users" do

    it "creates a new valid guest user" do
      User.new_guest.should be_valid
    end

    it "creates a guest user" do
      User.new_guest.should be_guest
    end

    it "saves guest user to the database" do
      lambda {
        User.new_guest
      }.should change(User, :count).by(1)
    end

  end

  describe "zip codes" do

    it "validates a correct us zip code" do
      u = build(:user, zip_code: '11201', country_code: 'US')
      u.should be_valid
    end

    it "validates an incorrect us zip code" do
      u = build(:user, zip_code: 'sl41eg', country_code: 'US')
      u.should_not be_valid
    end

    it "validates a correct uk zip code" do
      u = build(:user, zip_code: 'sl41eg', country_code: 'GB')
      u.should be_valid
    end

    it "validates an incorrect uk zip code" do
      u = build(:user, zip_code: '11201', country_code: 'GB')
      u.should_not be_valid
    end

    it "doesn't care about zip code validations in other countries" do
      u = build(:user, zip_code: '11201', country_code: 'BB')
      u.should be_valid
    end

  end

  describe "country" do

    it "validates a correct country code" do
      u = build(:user, country_code: 'US')
      u.should be_valid
    end

    it "validates an incorrect country code" do
      u = build(:user, country_code: 'UU')
      u.should_not be_valid
    end

    it "returns a country name from a country code" do
      user.country_code = 'US'
      user.country_name.should == 'United States'
    end

    it "returns nil if the country code is unknown" do
      user.country_code = "UU"
      user.country_name.should be_nil
    end

  end

  describe "has_list" do

    it "returns false if the user does not have a list" do
      u = build(:user)
      u.should_not have_list
    end

    it "returns true if the user does have a list" do
      u = create(:user)
      u.build_list!
      u.should have_list
    end

  end

  describe "complete_quiz!" do

    it "marks quiz as completed" do
      user.quiz_taken_at.should be_blank
      user.complete_quiz!
      user.quiz_taken_at.should be_present
    end
  end

  describe "full_name" do

    it "returns full name" do
      user = build(:user, first_name: "John", last_name: "Doe")
      user.full_name.should == "John Doe"
    end

    it "returns first name if user does not have a last name" do
      user = build(:user, first_name: "John", last_name: nil)
      user.full_name.should == "John"
    end

    it "returns nil if user does not have first and last name" do
      user = build(:user, first_name: nil, last_name: nil)
      user.full_name.should be_nil
    end

    it "sets first name from full name" do
      user = build(:user, first_name: nil, last_name: nil)
      user.full_name = "John Doe"
      user.first_name.should == "John"
    end

    it "sets last name from full name" do
      user = build(:user, first_name: nil, last_name: nil)
      user.full_name = "John Doe"
      user.last_name.should == "Doe"
    end

    it "sets first name for a user with more than two names" do
      user = build(:user, first_name: nil, last_name: nil)
      user.full_name = "John Seymour Doe"
      user.first_name.should == "John"
    end

    it "sets last name for a user with more than two names" do
      user = build(:user, first_name: nil, last_name: nil)
      user.full_name = "John Seymour Doe"
      user.last_name.should == "Seymour Doe"
    end

    it "sets a first name even if no last name is specified" do
      user = build(:user, first_name: nil, last_name: nil)
      user.full_name = "John"
      user.first_name.should == "John"
    end

    it "does not set a last name if full name does not include one" do
      user = build(:user, first_name: nil, last_name: nil)
      user.full_name = "John"
      user.last_name.should be_nil
    end

    it "handles a nil value" do
      user = build(:user, first_name: nil, last_name: nil)
      user.full_name = nil
      user.first_name.should be_nil
      user.last_name.should be_nil
    end

    it "handles an empty value" do
      user = build(:user, first_name: nil, last_name: nil)
      user.full_name = nil
      user.first_name.should be_nil
      user.last_name.should be_nil
    end

  end

end
