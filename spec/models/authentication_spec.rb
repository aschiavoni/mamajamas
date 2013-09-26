require 'spec_helper'

describe Authentication do

  it "indicates an unexpired access token" do
    auth = create(:authentication)
    auth.access_token_expired?.should be_false
  end

  it "indicates an expired access token" do
    auth = create(:authentication, access_token_expires_at: 2.days.ago)
    auth.access_token_expired?.should be_true
  end
end
