require_relative '../../app/models/omniauth_hash_parser'
require_relative '../support/features/omniauth_helpers'

describe OmniauthHashParser do
  include Features::OmniauthHelpers

  it "parses provider" do
    oauth_hash = mock_google_omniauth
    OmniauthHashParser.new(oauth_hash).provider.should == "google"
  end

  it "parses uid" do
    oauth_hash = mock_google_omniauth("99009")
    OmniauthHashParser.new(oauth_hash).uid.should == "99009"
  end

  it "parses access_token" do
    oauth_hash = mock_google_omniauth
    oauth_hash.credentials.token = "999999999999"
    OmniauthHashParser.new(oauth_hash).access_token.should == "999999999999"
  end

  it "parses access_token_expires_at" do
    oauth_hash = mock_google_omniauth
    result = OmniauthHashParser.new(oauth_hash)
    result.access_token_expires_at.should be_an_instance_of(Time)
  end

  it "ignores a blank access_token_expires_at" do
    oauth_hash = mock_google_omniauth
    oauth_hash.credentials.expires_at = nil
    result = OmniauthHashParser.new(oauth_hash)
    result.access_token_expires_at.should be_nil
  end

end
