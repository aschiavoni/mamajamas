require 'isolated_spec_helper'
require 'facebook_user_creator'
require 'facebook_user_finder'
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
    user.should_receive(:send_welcome_email)
    FacebookUserFinder.stub(:find) { user }
    FacebookUserCreator.any_instance.should_receive(:update_user).
      with(user).and_return(user)

    FacebookUserCreator.from_oauth(auth)
  end

  it "should create a user based from an oauth hash" do
    auth = auth(auth_hash)
    user_stub = stub(:send_welcome_email)
    user_stub.should_receive(:send_welcome_email)
    FacebookUserFinder.stub(:find) { nil }
    FacebookUserCreator.any_instance.should_receive(:create_user).and_return(user_stub)
    FacebookUserCreator.from_oauth(auth)
  end

  it "should send welcome email" do
    auth = auth(auth_hash)
    user_stub = stub
    FacebookUserFinder.stub(:find) { nil }
    FacebookUserCreator.any_instance.should_receive(:create_user).and_return(user_stub)
    user_stub.should_receive(:send_welcome_email)
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
      @user.stub(:send_welcome_email)
      FacebookUserFinder.stub(:find) { @user }
    end

    it "should find user" do
      @creator.update_or_create.should == @user
    end

    it "should update user" do
      @creator.should_receive(:update_user).and_return(@user)
      @creator.update_or_create
    end

    it "should not create user" do
      @creator.should_not_receive(:create_user)
      @creator.update_or_create
    end

  end

  it "should create a user if the facebook user has not already authenticated" do
    auth = auth(auth_hash)
    FacebookUserFinder.stub(:find) { nil }
    creator = FacebookUserCreator.new(auth)
    creator.stub(:random_password).and_return("kjdslkjlskjf")

    User.
      should_receive(:create!).
      with(hash_including(:uid), hash_including(:without_protection)).
      and_return(stub.as_null_object)

    creator.update_or_create
  end

  it "should update a user if the user has already authenticated" do
    user = double
    auth = auth(auth_hash)
    creator = FacebookUserCreator.new(auth)
    FacebookUserFinder.stub(:find) { user }

    user.should_receive(:send_welcome_email)
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
    FacebookUserFinder.stub(:find) { user }

    user.should_receive(:send_welcome_email)
    user.should_receive(:guest?).and_return(true)
    user.
      should_receive(:update_attributes).
      with(hash_including(:uid, :username), hash_including(:without_protection))

    creator.update_or_create
  end

end
