require "spec_helper"

describe InvitationMailer do

  describe "invitation" do

    let(:invite) { create(:invite, from: "John") }

    let(:mail) { InvitationMailer.invitation(invite.id) }

    it "renders the headers" do
      mail.subject.should eq("Check out Mamajamas.com")
      mail.to.should eq([invite.email])
      mail.from.should eq([invite.user.email])
    end

    it "renders the body" do
      mail.body.encoded.should match("Create your own baby gear list at Mamajamas:")
    end

    it "includes a link to mamajamas" do
      mail.body.encoded.should match("http://www.mamajamas.com")
    end

    it "includes a greeting" do
      mail.body.encoded.should match("Hello #{invite.name},")
    end

    it "includes a message" do
      mail.body.encoded.should match(invite.message)
    end

    it "includes the sender name" do
      mail.body.encoded.should match(invite.from)
    end

    it "sets invite sent at timestamp" do
      expect { mail }.to change {
        invite.reload
        invite.invite_sent_at
      }.from(NilClass).to(Time)
    end

  end

end
