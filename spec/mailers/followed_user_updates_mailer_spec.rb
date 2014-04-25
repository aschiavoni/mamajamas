require 'spec_helper'

describe FollowedUserUpdatesMailer do

  describe "daily digest" do

    let(:user) { create(:user, first_name: "Jane") }
    let(:followed) { create(:user, first_name: "John") }
    let(:mail) { FollowedUserUpdatesMailer.daily_digest(user.id) }

    before(:each) do
      user.follow!(followed)
      list = create(:list, user: followed)
      create(:list_item, list: list)
      create(:list_item, list: list)
    end

    it "renders the headers" do
      mail.subject.should eq("Mamajamas updates from your friends")
      mail.to.should eq([ user.email ])
      mail.from.should eq(["automom@mamajamas.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("has added new gear")
    end

    it "includes a greeting" do
      mail.body.encoded.should match("Hi #{user.first_name}")
    end

  end

end
