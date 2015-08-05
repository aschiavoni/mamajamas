# require 'spec_helper'

class MockUsernameFinder
  def self.find(u); u; end
end

describe OauthUserCreator, :type => :model do

  let(:oauth) do
    OmniauthHashParser.new(mock_facebook_omniauth)
  end

  it "returns a user when updating a user" do
    user = create(:user)
    allow(OauthUserFinder).to receive(:find) { user }
    expect(UpdatesOauthUser).to receive(:update).
      with(user, oauth, MockUsernameFinder) { user }

    expect(OauthUserCreator.new(oauth, MockUsernameFinder).update_or_create).
      to be_an_instance_of(User)
  end

  it "returns a user when creating a user" do
    allow(OauthUserFinder).to receive(:find) { nil }
    expect(CreatesOauthUser).to receive(:create).
      with(oauth.extracted_username, oauth) { create(:user) }

    expect(OauthUserCreator.new(oauth, MockUsernameFinder).update_or_create).
      to be_an_instance_of(User)
  end

  it "updates a user from an oauth hash" do
    user = create(:user)
    allow(OauthUserFinder).to receive(:find) { user }
    expect(UpdatesOauthUser).to receive(:update).
      with(user, oauth, MockUsernameFinder)

    OauthUserCreator.new(oauth, MockUsernameFinder).update_or_create
  end

  it "creates a user from an oauth hash" do
    allow(OauthUserFinder).to receive(:find) { nil }
    expect(CreatesOauthUser).to receive(:create).
      with(oauth.extracted_username, oauth) { double.as_null_object }

    OauthUserCreator.new(oauth, MockUsernameFinder).update_or_create
  end

  it "sends welcome email for guest users" do
    user_stub = double
    allow(OauthUserFinder).to receive(:find) { nil }
    expect(CreatesOauthUser).to receive(:create).and_return(user_stub)
    expect(user_stub).to receive(:send_welcome_email)
    OauthUserCreator.new(oauth, MockUsernameFinder).update_or_create
  end

end
