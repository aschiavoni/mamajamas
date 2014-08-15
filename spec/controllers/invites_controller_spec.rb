require 'spec_helper'

describe InvitesController, :type => :controller do

  let(:user) { create(:user) }
  let(:invite_params) {
    {
      email: "user@example.com",
      name: "Bill Carson",
      picture_url: "https://mamajamas-dev.s3.amazonaws.com/uploads/user/profile_picture/103/friend_yDnr5YfbJCH.gif",
      uid: "3232445",
      provider: "google"
    }
  }

  before(:each) do
    sign_in user
  end

  describe "create" do

    it "is successful" do
      post :create, invite: invite_params, format: :json
      expect(response).to be_success
    end

    it "assigns invite" do
      post :create, invite: invite_params, format: :json
      expect(assigns(:invite)).not_to be_nil
    end

    it "renders template" do
      post :create, invite: invite_params, format: :json
      expect(response).to render_template("create")
    end

    it "creates new invite" do
      expect {
        post :create, invite: invite_params, format: :json
      }.to change(user.invites, :count).by(1)
    end

    it "does not set invite sent at" do
      post :create, invite: invite_params, format: :json
      expect(assigns(:invite).invite_sent_at).to be_nil
    end

    it "sets invite sent at for facebook invites" do
      invite_params.merge!(provider: "facebook")
      post :create, invite: invite_params, format: :json
      expect(assigns(:invite).invite_sent_at).not_to be_nil
    end

    it "sends an invitation email for mamajamas invites" do
      invite_params.merge!(provider: "mamajamas")
      expect {
        post :create, invite: invite_params, format: :json
      }.to change(ActionMailer::Base.deliveries, :size).by(1)
    end

  end

end
