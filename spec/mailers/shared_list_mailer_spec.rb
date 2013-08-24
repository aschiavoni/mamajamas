require "spec_helper"

describe SharedListMailer do

  describe "shared" do

    let(:user) { create(:user, first_name: "Jane") }

    let(:mail) { SharedListMailer.shared(user.id) }

    it "renders the headers" do
      mail.subject.should eq("Your List is Saved!")
      mail.to.should eq([ user.email ])
      mail.from.should eq([ "automom@mamajamas.com" ])
      mail.bcc.should eq([ "angie@mamajamas.com" ])
    end

    it "renders the body" do
      mail.body.encoded.should match("Your Mamajamas list has been saved.")
    end

    # it "includes a greeting" do
    #   mail.body.encoded.should match("Hi #{user.first_name}")
    # end

    it "includes a link to the shared list" do
      mail.body.encoded.should match("http://.*/#{user.username}")
    end

  end

end
