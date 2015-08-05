require 'spec_helper'

describe CreatesOauthUser, :type => :model do

  let (:oauth) { OmniauthHashParser.new(mock_facebook_omniauth) }
  let (:username) { "billg" }

  it "creates a user" do
    expect(User).to receive(:create!) { double.as_null_object }
    CreatesOauthUser.create(username, oauth)
  end

  it "creates a user witha a random password" do
    expect(GeneratesRandomPassword).to receive(:generate) { "whatever" }
    CreatesOauthUser.create(username, oauth)
  end

  it "creates an authentication" do
    aa = double
    expect(AddsAuthentication).to receive(:new).with(an_instance_of(User)) { aa }
    expect(aa).to receive(:from_oauth).with(oauth)
    CreatesOauthUser.create(username, oauth)
  end

  it "returns a user" do
    expect(CreatesOauthUser.create(username, oauth)).to be_an_instance_of(User)
  end

end
