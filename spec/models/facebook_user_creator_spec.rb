require 'isolated_spec_helper'
require 'facebook_user_creator'
require 'omniauth'
require 'active_support/core_ext/string'

class User; end

describe FacebookUserCreator do

  let(:auth_hash) do
    {
      "provider"  => "facebook",
      "uid"       => 12345,
      "info" => {
        "email" => "12345@email.com",
        "nickname" => "john",
        "first_name" => "John",
        "last_name"  => "Doe",
        "name"       => "John Doe"
      },
      "credentials" => {
        "token" => "12345",
        "expires_at" => 232171200,
        "expires" => true
      },
      "extra" => {
        "raw_info" => {
          "username" => "john",
          "first_name" => "John",
          "last_name" => "Doe"
        }
      }
    }
  end

  def auth(hash)
    OmniAuth::AuthHash.new hash
  end

  it "should update a user based from an oauth hash" do
    auth = auth(auth_hash)
    user = User.new
    FacebookUserCreator.any_instance.stub(:find_user).and_return(user)

    FacebookUserCreator.any_instance.should_receive(:update_user).with(user)

    FacebookUserCreator.from_oauth(auth)
  end

  it "should create a user based from an oauth hash" do
    auth = auth(auth_hash)
    FacebookUserCreator.any_instance.stub(:find_user).
      and_return(nil)

    FacebookUserCreator.any_instance.should_receive(:create_user)

    FacebookUserCreator.from_oauth(auth)
  end

  context "facebook username" do

    it "should return username if specified" do
      auth = auth(auth_hash)
      creator = FacebookUserCreator.new(auth)
      creator.facebook_username.should == "john"
    end

    it "should return full name if username is not in auth hash" do
      auth = auth(auth_hash.merge({
        "extra" => {
          "raw_info" => {
            "username" => nil,
            "first_name" => "John",
            "last_name" => "Doe"
          }
        }
      }))
      creator = FacebookUserCreator.new(auth)
      creator.facebook_username.should == "JohnDoe"
    end
  end

  context "expires at timestamp" do

    it "should find expires at timestamp if available" do
      auth = auth(auth_hash)
      creator = FacebookUserCreator.new(auth)
      Time.should_receive(:at).with(auth.credentials.expires_at).
        and_return(Time.now)

      creator.expires_at
    end

    it "should return nil for expires_at if not in auth hash" do
      auth = auth(auth_hash.merge("credentials" => {}))
      creator = FacebookUserCreator.new(auth)

      expect(creator.expires_at).to be_nil
    end

  end

  context "user has already registered with facebook" do

    before(:each) do
      @auth = auth(auth_hash)
      @creator = FacebookUserCreator.new(@auth)

      @user = double
      @user.stub(:guest? => false)
      @user.stub(:update_attributes)
      @creator.stub(:find_user_by_facebook_uid).and_return(@user)
    end

    it "should find user" do
      @creator.update_or_create.should == @user
    end

    it "should look for user by facebook uid" do
      @creator.should_receive(:find_user_by_facebook_uid)
      @creator.update_or_create
    end

    it "should look for user by facebook email" do
      @creator.should_not_receive(:find_user_by_facebook_email)
      @creator.update_or_create
    end

    it "should update user" do
      @creator.should_receive(:update_user)
      @creator.update_or_create
    end

    it "should not create user" do
      @creator.should_not_receive(:create_user)
      @creator.update_or_create
    end

  end

  context "user has already registered with facebook email" do

    before(:each) do
      @auth = auth(auth_hash)
      @creator = FacebookUserCreator.new(@auth)

      @user = double
      @user.stub(:guest? => false)
      @user.stub(:update_attributes)

      @creator.stub(:find_user_by_facebook_uid).and_return(nil)
      @creator.stub(:find_user_by_facebook_email).and_return(@user)
    end

    it "should find user" do
      @creator.update_or_create.should == @user
    end

    it "should look for user by facebook uid" do
      @creator.should_receive(:find_user_by_facebook_uid)
      @creator.update_or_create
    end

    it "should look for user by facebook email" do
      @creator.should_receive(:find_user_by_facebook_email)
      @creator.update_or_create
    end

    it "should update user" do
      @creator.should_receive(:update_user)
      @creator.update_or_create
    end

    it "should not create user" do
      @creator.should_not_receive(:create_user)
      @creator.update_or_create
    end

  end

  it "should create a user if the facebook user has not already authenticated" do
    auth = auth(auth_hash)
    creator = FacebookUserCreator.new(auth)
    creator.stub(:find_user).and_return(nil)
    creator.stub(:random_password).and_return("kjdslkjlskjf")

    User.
      should_receive(:create!).
      with(hash_including(:uid), hash_including(:without_protection))

    creator.update_or_create
  end

  it "should update a user if the user has already authenticated" do
    user = double
    auth = auth(auth_hash)
    creator = FacebookUserCreator.new(auth)
    creator.stub(:find_user).and_return(user)

    user.should_receive(:guest?).and_return(false)
    user.
      should_receive(:update_attributes).
      with(hash_including(:uid), hash_including(:without_protection))

    creator.update_or_create
  end

  it "should update a username and email if it is a guest user" do
    user = double
    auth = auth(auth_hash)
    creator = FacebookUserCreator.new(auth)
    creator.stub(:find_user).and_return(user)

    user.should_receive(:guest?).and_return(true)
    user.
      should_receive(:update_attributes).
      with(hash_including(:uid, :username), hash_including(:without_protection))

    creator.update_or_create
  end

end
