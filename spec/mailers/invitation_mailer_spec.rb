require "spec_helper"

describe InvitationMailer, :type => :mailer do

  describe "invitation" do

    let(:invite) { create(:invite, from: "John") }

    let(:mail) { InvitationMailer.invitation(invite.id) }

    it "renders the headers" do
      expect(mail.subject).to eq("Check out Mamajamas.com")
      expect(mail.to).to eq([invite.email])
      expect(mail.from).to eq([invite.user.email])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Create your own baby gear list at Mamajamas:")
    end

    it "includes a link to mamajamas" do
      expect(mail.body.encoded).to match("http://www.mamajamas.com")
    end

    it "includes a greeting" do
      expect(mail.body.encoded).to match("Hello #{invite.name},")
    end

    it "includes a message" do
      expect(mail.body.encoded).to match(invite.message)
    end

    it "includes the sender name" do
      expect(mail.body.encoded).to match(invite.from)
    end

    it "sets invite sent at timestamp" do
      expect { mail }.to change {
        invite.reload
        invite.invite_sent_at
      }.from(NilClass).to(Time)
    end

  end

end
