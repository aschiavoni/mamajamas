# require 'spec_helper'

class MockUsernameFinder
  def self.find(u); u; end
end

describe OauthUserCreator do

  let(:oauth) do
    OmniauthHashParser.new(mock_facebook_omniauth)
  end

  it "returns a user when updating a user" do
    user = create(:user)
    OauthUserFinder.stub(:find) { user }
    UpdatesOauthUser.should_receive(:update).
      with(user, oauth, MockUsernameFinder) { user }

    OauthUserCreator.new(oauth, MockUsernameFinder).update_or_create.
      should be_an_instance_of(User)
  end

  it "returns a user when creating a user" do
    OauthUserFinder.stub(:find) { nil }
    CreatesOauthUser.should_receive(:create).
      with(oauth.extracted_username, oauth) { create(:user) }

    OauthUserCreator.new(oauth, MockUsernameFinder).update_or_create.
      should be_an_instance_of(User)
  end

  it "updates a user from an oauth hash" do
    user = create(:user)
    OauthUserFinder.stub(:find) { user }
    UpdatesOauthUser.should_receive(:update).
      with(user, oauth, MockUsernameFinder)

    OauthUserCreator.new(oauth, MockUsernameFinder).update_or_create
  end

  it "creates a user from an oauth hash" do
    OauthUserFinder.stub(:find) { nil }
    CreatesOauthUser.should_receive(:create).
      with(oauth.extracted_username, oauth) { stub.as_null_object }

    OauthUserCreator.new(oauth, MockUsernameFinder).update_or_create
  end

  it "sends welcome email for guest users" do
    user_stub = stub
    OauthUserFinder.stub(:find) { nil }
    CreatesOauthUser.should_receive(:create).and_return(user_stub)
    user_stub.should_receive(:send_welcome_email)
    OauthUserCreator.new(oauth, MockUsernameFinder).update_or_create
  end

end
