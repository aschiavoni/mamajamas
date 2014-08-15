require 'spec_helper'

describe ListSettingsController, :type => :controller do

  let(:user) { create(:user) }

  before(:each) { sign_in user }

  describe "edit" do

    it "returns http success" do
      get 'edit'
      expect(response).to be_success
    end

    it "assigns view" do
      get 'edit'
      expect(assigns(:settings)).to be_an_instance_of(Forms::ListSettingsView)
    end

  end

  describe "update" do

    it "redirects to settings after update" do
      expect_any_instance_of(Forms::ListSettingsView).
        to receive(:update!).and_return(true)
      put :update, settings: { privacy: 0 }
      expect(response).to redirect_to(settings_path)
    end

    it "renders edit template if update fails" do
      expect_any_instance_of(Forms::ListSettingsView).
        to receive(:update!).and_return(false)
      put :update, settings: { privacy: 0 }
      expect(response).to render_template("edit")
    end
  end

end
