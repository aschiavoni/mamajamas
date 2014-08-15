require 'spec_helper'

describe User, :type => :model do

  let(:user) { create(:user, quiz_taken_at: nil) }

  describe "slugs" do

    it "should have slugged value" do
      new_user = create(:user)
      expect(new_user.slug).to eq(new_user.username)
    end

    it "should update slug when username changes" do
      new_user = create(:user)
      new_user.update_attributes!(username: "testxxx1199")
      expect(new_user.slug).to eq("testxxx1199")
    end
  end

  describe "set username" do

    it "sets a username from email if name not provided" do
      new_user = create(:user, email: "jackdoe@example.com", username: nil)
      expect(new_user.username).to eq("jackdoe")
    end

    it "sets a username from full name" do
      new_user = create(:user,
                        first_name: "Jonathan", last_name: "Doe", username: nil)
      expect(new_user.username).to eq("jonathandoe")
    end

    it "sets a username from first name" do
      new_user = create(:user,
                        first_name: "Jane", last_name: nil, username: nil)
      expect(new_user.username).to eq("jane")
    end

    it "fails to create user if a username cannot be generated" do
      expect {
        new_user = create(:user,
                          first_name: nil, last_name: nil,
                          username: nil, email: nil)
      }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it "downcases usernames" do
      new_user = create(:user, username: "JackDoe")
      expect(new_user.username).to eq("jackdoe")
    end

  end

  describe "facebook connected" do

    it "should be facebook connected" do
      create(:authentication, user: user, provider: "facebook")
      expect(user).to be_facebook_connected
    end

    it "should not be facebook connected" do
      user.clear_facebook!
      expect(user).not_to be_facebook_connected
    end

  end

  describe "google connected" do

    it "is connected to google" do
      create(:authentication, user: user, provider: "google")
      expect(user).to be_google_connected
    end

    it "is not connected to google" do
      user.clear_google!
      expect(user).not_to be_google_connected
    end

    it "has expired google access token" do
      user.clear_google!
      create(:authentication, user: user,
             provider: "google", access_token_expires_at: 2.days.ago)
      expect(user).not_to be_google_connected
    end

    it "returns empty array when user does not have google friends" do
      user.clear_google!
      expect(user.google_friends).to be_empty
    end

    it "retrieves google friends" do
      create(:authentication, user: user, provider: "google")
      create(:social_friends, user: user,
             provider: "google", friends: [ { id: 10 } ])
      expect(user.google_friends).not_to be_empty
    end

  end

  describe "relationships" do

    describe "created at" do

      it "return true if relationships have been created" do
        user.relationships_created_at = Time.now.utc
        user.save!

        expect(user.auto_created_relationships?).to be_truthy
      end

      it "return false if relationships have been created" do
        expect(user.auto_created_relationships?).to be_falsey
      end

    end

    describe "follow user" do

      let(:other_user) { create(:user) }

      before(:each) do
        user.follow! other_user
      end

      it "should be following other user" do
        expect(user).to be_following(other_user)
      end

      it "should include other user in followed users list" do
        expect(user.followed_users).to include(other_user)
      end

      it "should be in other user's followers list" do
        expect(other_user.followers).to include(user)
      end

      describe "unfollow other user" do

        before(:each) do
          user.unfollow! other_user
        end

        it "should not be following other user" do
          expect(user).not_to be_following(other_user)
        end

        it "should not include other user in followed users list" do
          expect(user.followed_users).not_to include(other_user)
        end

      end

    end

    it "should respond to relationships" do
      expect(user).to respond_to :relationships
    end

    it "should respond to followed_users" do
      expect(user).to respond_to :followed_users
    end

    it "should respond to reverse_relationships" do
      expect(user).to respond_to :reverse_relationships
    end

    it "should respond to followers" do
      expect(user).to respond_to :followers
    end

    it "should respond to following?" do
      expect(user).to respond_to :following?
    end

    it "should respond to follow!" do
      expect(user).to respond_to :follow!
    end

    it "should respond to unfollow!" do
      expect(user).to respond_to :unfollow!
    end

  end

  describe "age" do

    it "should return nil if no birthday specified" do
      user.birthday = nil
      expect(user.age).to be_nil
    end

    it "should return a user's age" do
      now = Date.new(2013, 2, 7)
      user.birthday = Date.new(1977, 5, 11)
      expect(user.age(now)).to eq(35)
    end

  end

  describe "email" do

    it "displays user's email address" do
      expect(user.display_email).to eq(user.email)
    end

    it "displays 'Guest' for email address for guest users" do
      expect(User.new_guest.display_email).to eq('Guest')
    end

  end

  describe "guest users" do

    it "creates a new valid guest user" do
      expect(User.new_guest).to be_valid
    end

    it "creates a guest user" do
      expect(User.new_guest).to be_guest
    end

    it "saves guest user to the database" do
      expect {
        User.new_guest
      }.to change(User, :count).by(1)
    end

  end

  describe "zip codes" do

    it "validates a correct us zip code" do
      u = build(:user, zip_code: '11201', country_code: 'US')
      expect(u).to be_valid
    end

    it "validates an incorrect us zip code" do
      u = build(:user, zip_code: 'sl41eg', country_code: 'US')
      expect(u).not_to be_valid
    end

    it "validates a correct uk zip code" do
      u = build(:user, zip_code: 'sl41eg', country_code: 'GB')
      expect(u).to be_valid
    end

    it "validates an incorrect uk zip code" do
      u = build(:user, zip_code: '11201', country_code: 'GB')
      expect(u).not_to be_valid
    end

    it "doesn't care about zip code validations in other countries" do
      u = build(:user, zip_code: '11201', country_code: 'BB')
      expect(u).to be_valid
    end

  end

  describe "country" do

    it "validates a correct country code" do
      u = build(:user, country_code: 'US')
      expect(u).to be_valid
    end

    it "validates an incorrect country code" do
      u = build(:user, country_code: 'UU')
      expect(u).not_to be_valid
    end

    it "returns a country name from a country code" do
      user.country_code = 'US'
      expect(user.country_name).to eq('United States')
    end

    it "returns nil if the country code is unknown" do
      user.country_code = "UU"
      expect(user.country_name).to be_nil
    end

  end

  describe "has_list" do

    it "returns false if the user does not have a list" do
      u = build(:user)
      expect(u).not_to have_list
    end

    it "returns true if the user does have a list" do
      u = create(:user)
      u.build_list!
      expect(u).to have_list
    end

  end

  describe "complete_quiz!" do

    it "marks quiz as completed" do
      expect(user.quiz_taken_at).to be_blank
      user.complete_quiz!
      expect(user.quiz_taken_at).to be_present
    end
  end

  describe "full_name" do

    it "returns full name" do
      user = build(:user, first_name: "John", last_name: "Doe")
      expect(user.full_name).to eq("John Doe")
    end

    it "returns first name if user does not have a last name" do
      user = build(:user, first_name: "John", last_name: nil)
      expect(user.full_name).to eq("John")
    end

    it "returns nil if user does not have first and last name" do
      user = build(:user, first_name: nil, last_name: nil)
      expect(user.full_name).to be_nil
    end

    it "sets first name from full name" do
      user = build(:user, first_name: nil, last_name: nil)
      user.full_name = "John Doe"
      expect(user.first_name).to eq("John")
    end

    it "sets last name from full name" do
      user = build(:user, first_name: nil, last_name: nil)
      user.full_name = "John Doe"
      expect(user.last_name).to eq("Doe")
    end

    it "sets first name for a user with more than two names" do
      user = build(:user, first_name: nil, last_name: nil)
      user.full_name = "John Seymour Doe"
      expect(user.first_name).to eq("John")
    end

    it "sets last name for a user with more than two names" do
      user = build(:user, first_name: nil, last_name: nil)
      user.full_name = "John Seymour Doe"
      expect(user.last_name).to eq("Seymour Doe")
    end

    it "sets a first name even if no last name is specified" do
      user = build(:user, first_name: nil, last_name: nil)
      user.full_name = "John"
      expect(user.first_name).to eq("John")
    end

    it "does not set a last name if full name does not include one" do
      user = build(:user, first_name: nil, last_name: nil)
      user.full_name = "John"
      expect(user.last_name).to be_nil
    end

    it "handles a nil value" do
      user = build(:user, first_name: nil, last_name: nil)
      user.full_name = nil
      expect(user.first_name).to be_nil
      expect(user.last_name).to be_nil
    end

    it "handles an empty value" do
      user = build(:user, first_name: nil, last_name: nil)
      user.full_name = nil
      expect(user.first_name).to be_nil
      expect(user.last_name).to be_nil
    end

  end

  describe "email preferences" do

    let(:user) { build(:user, email_preferences: nil) }

    context "email preference null" do

      it "treats email as enabled when not set" do
        expect(user.new_follower_notifications_enabled?).to be_truthy
      end

      it "returns false for disabled" do
        expect(user.new_follower_notifications_disabled?).to be_falsey
      end

      it "sets email preference as disabled" do
        user.new_follower_notifications_disabled = true
        expect(user.email_preferences).to eq({
          "new_follower_notifications_disabled" => true
        })
      end

      it "sets email preference as enabled" do
        user.new_follower_notifications_enabled = true
        expect(user.email_preferences).to eq({
          "new_follower_notifications_disabled" => false
        })
      end

    end

    context "email preference disabled" do

      before(:each) {
        user.new_follower_notifications_disabled = true
      }

      it "returns false for enabled" do
        expect(user.new_follower_notifications_enabled?).to be_falsey
      end

      it "returns true for disabled" do
        expect(user.new_follower_notifications_disabled?).to be_truthy
      end

    end

    context "email preference enabled" do

      before(:each) {
        user.new_follower_notifications_disabled = false
      }

      it "returns true for enabled" do
        expect(user.new_follower_notifications_enabled?).to be_truthy
      end

      it "returns false for disabled" do
        expect(user.new_follower_notifications_disabled?).to be_falsey
      end

    end

  end

  describe "user settings" do

    let(:user) { create(:user) }

    it "defaults show_bookmarklet_prompt to true" do
      expect(user.show_bookmarklet_prompt).to be_truthy
    end

    it "sets show_bookmarklet_prompt" do
      user.show_bookmarklet_prompt = false
      expect(user.show_bookmarklet_prompt).to be_falsey
    end

  end

end
