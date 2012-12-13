require "spec_helper"

describe RelationshipMailer do

  describe 'follower notification' do

    let(:followed) { create(:user) }
    let(:follower) { create(:user) }
    let(:relationship) { follower.follow!(followed) }
    let(:mail) { RelationshipMailer.follower_notification(relationship) }

    it "renders the subject" do
      mail.subject.should == "New follower"
    end

    it "sends to the followed user" do
      mail.to.should include(followed.email)
    end

    it "sends from the correct email address" do
      mail.from.should include("no-reply@mamajamas.com")
    end

    it "includes followed username" do
      mail.body.encoded.should match(followed.username)
    end

    it "includes follower username" do
      mail.body.encoded.should match(follower.username)
    end

    it "sets notification delivered at timestamp" do
      expect { mail }.to change {
        relationship.delivered_notification_at
      }.from(NilClass).to(Time)
    end

    describe "follower has full name" do

      let(:follower) { create(:user, first_name: "John", last_name: "Doe") }

      it "includes follower full name" do
        mail.body.encoded.should match("John Doe")
      end

    end

    describe "followed has full name" do

      let(:followed) { create(:user, first_name: "Jane", last_name: "Doe") }

      it "includes followed full name" do
        mail.body.encoded.should match("Jane Doe")
      end

    end

  end

end
