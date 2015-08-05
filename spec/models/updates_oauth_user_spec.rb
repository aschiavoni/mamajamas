require 'spec_helper'

class MockUsernameFinder
  def self.find(u); u; end
end

describe UpdatesOauthUser, :type => :model do

  let(:user) { create(:user) }

  let(:guest) { create(:user, guest: true) }

  let(:oauth) { OmniauthHashParser.new(mock_facebook_omniauth) }

  it "promotes guest user" do
    expect(user).to receive(:update_attributes!).with(hash_including(guest: false))
    UpdatesOauthUser.update(user, oauth, MockUsernameFinder)
  end

  it "sets username if user is a guest" do
    expect(guest).to receive(:update_attributes!).
      with(hash_including(username: oauth.extracted_username))
    UpdatesOauthUser.update(guest, oauth, MockUsernameFinder)
  end

  it "sets email if user is a guest" do
    expect(guest).to receive(:update_attributes!).
      with(hash_including(email: oauth.email))
    UpdatesOauthUser.update(guest, oauth, MockUsernameFinder)
  end

  it "sets first name if user is a guest" do
    expect(guest).to receive(:update_attributes!).
      with(hash_including(first_name: oauth.first_name))
    UpdatesOauthUser.update(guest, oauth, MockUsernameFinder)
  end

  it "sets last name if user is a guest" do
    expect(guest).to receive(:update_attributes!).
      with(hash_including(last_name: oauth.last_name))
    UpdatesOauthUser.update(guest, oauth, MockUsernameFinder)
  end

  it "adds an oauth authentication" do
    aa = double
    expect(AddsAuthentication).to receive(:new).with(user) { aa }
    expect(aa).to receive(:from_oauth).with(oauth)
    UpdatesOauthUser.update(user, oauth, MockUsernameFinder)
  end

  it "returns a user" do
    expect(UpdatesOauthUser.update(user, oauth, MockUsernameFinder)).
      to be_an_instance_of(User)
  end

end
