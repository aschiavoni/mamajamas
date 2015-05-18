require "spec_helper"

describe SharedListMailer, :type => :mailer do

  describe "shared" do

    let(:user) { create(:user, first_name: "Jane") }

    let(:mail) { SharedListMailer.shared(user.id) }

    it "renders the headers" do
      expect(mail.subject).to eq("Your List is Saved!")
      expect(mail.to).to eq([ user.email ])
      expect(mail.from).to eq([ "automom@mamajamas.com" ])
      expect(mail.bcc).to eq([ "angie@mamajamas.com" ])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Your Mamajamas list has been saved.")
    end

    # it "includes a greeting" do
    #   mail.body.encoded.should match("Hi #{user.first_name}")
    # end

    it "includes a link to the shared list" do
      expect(mail.body.encoded).to match("http://.*/#{user.username}")
    end

  end

end
