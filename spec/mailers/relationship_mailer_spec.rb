require "spec_helper"

describe RelationshipMailer, :type => :mailer do

  describe 'follower notification' do

    let(:followed) { create(:user) }
    let(:follower) { create(:user) }
    let(:relationship) { follower.follow!(followed) }
    let(:mail) { RelationshipMailer.follower_notification(relationship.id) }

    it "renders the subject" do
      expect(mail.subject).to match(/#{follower.username}/)
    end

    it "sends to the followed user" do
      expect(mail.to).to include(followed.email)
    end

    it "sends from the correct email address" do
      expect(mail.from).to include("automom@mamajamas.com")
    end

    it "includes followed username" do
      expect(mail.body.encoded).to match(followed.username)
    end

    it "includes follower username" do
      expect(mail.body.encoded).to match(follower.username)
    end

    it "sets notification delivered at timestamp" do
      expect { mail }.to change {
        relationship.reload
        relationship.delivered_notification_at
      }.from(NilClass).to(Time)
    end

    describe "follower has full name" do

      let(:follower) { create(:user, first_name: "John", last_name: "Doe") }

      it "includes follower full name" do
        expect(mail.body.encoded).to match("John Doe")
      end

    end

    describe "followed has full name" do

      let(:followed) { create(:user, first_name: "Jane", last_name: "Doe") }

      it "includes followed full name" do
        expect(mail.body.encoded).to match("Jane Doe")
      end

    end

  end

end
