require 'spec_helper'

describe ListSettingsController do

  let(:user) { create(:user) }

  before(:each) { sign_in user }

  describe "edit" do

    it "returns http success" do
      get 'edit'
      response.should be_success
    end

    it "assigns view" do
      get 'edit'
      assigns(:settings).should be_an_instance_of(Forms::ListSettingsView)
    end

  end

  describe "update" do

    it "redirects to settings after update" do
      Forms::ListSettingsView.any_instance.
        should_receive(:update!).and_return(true)
      put :update, settings: { privacy: 0 }
      response.should redirect_to(settings_path)
    end

    it "renders edit template if update fails" do
      Forms::ListSettingsView.any_instance.
        should_receive(:update!).and_return(false)
      put :update, settings: { privacy: 0 }
      response.should render_template("edit")
    end
  end

end
