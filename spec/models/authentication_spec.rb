require 'spec_helper'

describe Authentication, :type => :model do

  it "indicates an unexpired access token" do
    auth = create(:authentication)
    expect(auth.access_token_expired?).to be_falsey
  end

  it "indicates an expired access token" do
    auth = create(:authentication, access_token_expires_at: 2.days.ago)
    expect(auth.access_token_expired?).to be_truthy
  end
end
