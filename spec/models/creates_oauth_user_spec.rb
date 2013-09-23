require 'spec_helper'

describe CreatesOauthUser do

  let (:oauth) { OmniauthHashParser.new(mock_facebook_omniauth) }
  let (:username) { "billg" }

  it "creates a user" do
    User.should_receive(:create!) { stub.as_null_object }
    CreatesOauthUser.create(username, oauth)
  end

  it "creates a user witha a random password" do
    GeneratesRandomPassword.should_receive(:generate) { "whatever" }
    CreatesOauthUser.create(username, oauth)
  end

  it "creates an authentication" do
    aa = stub
    AddsAuthentication.should_receive(:new).with(an_instance_of(User)) { aa }
    aa.should_receive(:from_oauth).with(oauth)
    CreatesOauthUser.create(username, oauth)
  end

  it "returns a user" do
    CreatesOauthUser.create(username, oauth).should be_an_instance_of(User)
  end

end
