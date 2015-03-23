require "spec_helper"

RSpec.describe LifecycleMailer, :type => :mailer do
  describe "post_due_ratings" do
    let(:user) { create(:user, first_name: "Jane") }
    let(:mail) { LifecycleMailer.post_due_ratings(user.id) }

    it "renders the lifecycle email headers" do
      expect(mail.subject).to eq("Time to review your baby gear")
      expect(mail.to).to eq([ user.email ])
      expect(mail.from).to eq(["automom@mamajamas.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Rate the products")
    end

    it "includes a greeting" do
      expect(mail.body.encoded).to match("Hi #{user.first_name}")
    end

  end

end
