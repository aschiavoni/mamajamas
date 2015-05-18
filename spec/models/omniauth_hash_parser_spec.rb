require_relative '../../app/models/omniauth_hash_parser'
require_relative '../support/features/omniauth_helpers'

describe OmniauthHashParser, :type => :model do
  include Features::OmniauthHelpers

  it "parses provider" do
    oauth_hash = mock_google_omniauth
    expect(OmniauthHashParser.new(oauth_hash).provider).to eq("google")
  end

  it "parses uid" do
    oauth_hash = mock_google_omniauth("99009")
    expect(OmniauthHashParser.new(oauth_hash).uid).to eq("99009")
  end

  it "parses access_token" do
    oauth_hash = mock_google_omniauth
    oauth_hash.credentials.token = "999999999999"
    expect(OmniauthHashParser.new(oauth_hash).access_token).to eq("999999999999")
  end

  it "parses access_token_expires_at" do
    oauth_hash = mock_google_omniauth
    result = OmniauthHashParser.new(oauth_hash)
    expect(result.access_token_expires_at).to be_an_instance_of(Time)
  end

  it "ignores a blank access_token_expires_at" do
    oauth_hash = mock_google_omniauth
    oauth_hash.credentials.expires_at = nil
    result = OmniauthHashParser.new(oauth_hash)
    expect(result.access_token_expires_at).to be_nil
  end

  it "parses email address" do
    oauth_hash = mock_google_omniauth("99933", "99933@example.com")
    result = OmniauthHashParser.new(oauth_hash)
    expect(result.email).to eq("99933@example.com")
  end

  it "parses first name" do
    oauth_hash = mock_google_omniauth("99933", "99933@example.com",
                                      "Julius", "Caesar")
    result = OmniauthHashParser.new(oauth_hash)
    expect(result.first_name).to eq("Julius")
  end

  it "parses last name" do
    oauth_hash = mock_google_omniauth("99933", "99933@example.com",
                                      "Julius", "Caesar")
    result = OmniauthHashParser.new(oauth_hash)
    expect(result.last_name).to eq("Caesar")
  end

  it "extracts a username from first name and last name" do
    oauth_hash = mock_google_omniauth("99933", "99933@example.com",
                                      "Julius", "Caesar")
    result = OmniauthHashParser.new(oauth_hash)
    expect(result.extracted_username).to eq("juliuscaesar")
  end

  it "parses extra info username" do
    oauth_hash = mock_facebook_omniauth("99933", "99933@example.com",
                                        "Julius", "Caesar")
    result = OmniauthHashParser.new(oauth_hash)
    expect(result.username).to eq("julius")
  end

end
