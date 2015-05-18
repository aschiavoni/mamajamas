require 'spec_helper'

describe FollowedUserUpdatesMailer, :type => :mailer do

  describe "notify" do

    let(:user) { create(:user, first_name: "Jane") }
    let(:followed) { create(:user, first_name: "John") }
    let(:mail) { FollowedUserUpdatesMailer.notify(user.id, followed, @updates) }

    before(:each) do
      user.follow!(followed)
      list = create(:list, user: followed)
      @updates = []
      @updates << create(:list_item, list: list)
      @updates << create(:list_item, list: list)
    end

    it "renders the headers" do
      expect(mail.subject).to eq("New gear has been added to #{'John'.possessive} list!")
      expect(mail.to).to eq([ user.email ])
      expect(mail.from).to eq(["automom@mamajamas.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("New gear has been added")
    end

    it "includes a greeting" do
      expect(mail.body.encoded).to match("Hi #{user.first_name}")
    end

  end

end
