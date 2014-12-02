require "spec_helper"

describe UserMailer, :type => :mailer do

  describe "welcome" do

    let(:user) { create(:user, first_name: "Jane") }

    let(:mail) { UserMailer.welcome(user.id) }

    it "renders the headers" do
      expect(mail.subject).to eq("Welcome to Mamajamas!")
      expect(mail.to).to eq([ user.email ])
      expect(mail.bcc).to eq([ "angie@mamajamas.com" ])
      expect(mail.from).to eq(["angie@mamajamas.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Congratulations")
    end

    it "includes a greeting" do
      expect(mail.body.encoded).to match("Hi #{user.first_name}")
    end

  end

end
