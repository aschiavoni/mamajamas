require 'spec_helper'

describe OauthUserFinder, :type => :model do

  let(:provider) { "facebook" }

  let(:auth_hash) do
    {
      "provider"  => provider,
      "uid"       => 12345,
      "info" => {
        "email" => "12345@example.com",
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

  let(:auth) { OmniauthHashParser.new(OmniAuth::AuthHash.new(auth_hash)) }

  it "finds a user from a uid in the auth hash" do
    user = create(:user)
    authentication = create(:authentication,
                            uid: auth_hash['uid'],
                            user: user,
                            provider: provider)
    expect(OauthUserFinder.new(auth).find).to eq(user)
  end

  it "finds a user from the email in the auth hash" do
    user = create(:user, email: auth_hash['info']['email'])
    expect(OauthUserFinder.new(auth).find).to eq(user)
  end

  it "does not find a facebook user" do
    expect(OauthUserFinder.new(auth).find).to eq(nil)
  end

end
