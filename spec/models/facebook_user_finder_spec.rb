require 'spec_helper'

describe FacebookUserFinder do

  let(:auth_hash) do
    {
      "provider"  => "facebook",
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

  let(:auth) { OmniAuth::AuthHash.new auth_hash }

  it "finds a user from a uid in the auth hash" do
    user = create(:user, uid: auth_hash['uid'], provider: auth_hash['provider'])
    FacebookUserFinder.new(auth).find.should == user
  end

  it "finds a user from the email in the auth hash" do
    user = create(:user, email: auth_hash['info']['email'])
    FacebookUserFinder.new(auth).find.should == user
  end

  it "does not find a facebook user" do
    FacebookUserFinder.new(auth).find.should == nil
  end

end
