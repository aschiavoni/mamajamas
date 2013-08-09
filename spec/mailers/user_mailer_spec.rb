require "spec_helper"

describe UserMailer do

  describe "welcome" do

    let(:user) { create(:user, first_name: "Jane") }

    let(:mail) { UserMailer.welcome(user.id) }

    it "renders the headers" do
      mail.subject.should eq("Welcome to Mamajamas!")
      mail.to.should eq([ user.email ])
      mail.bcc.should eq([ "angie@mamajamas.com" ])
      mail.from.should eq(["angie@mamajamas.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("beginning of Mamajamas")
    end

    it "includes a greeting" do
      mail.body.encoded.should match("Hi #{user.first_name}")
    end

    it "includes a link to the friends page" do
      mail.body.encoded.should match("/friends")
    end

    it "includes a link to angie's list page" do
      mail.body.encoded.should match("http://www.mamajamas.com/angie")
    end

    it "includes a link to user's list page" do
      mail.body.encoded.should match("/list")
    end

  end

end
