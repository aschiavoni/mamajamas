require 'spec_helper'

describe UsersController, :type => :controller do

  let(:user) { create(:user) }

  before(:each) do
    sign_in user
  end

  describe "edit" do

    it "should get edit page" do
      get :edit
      expect(response).to be_success
    end

    it "should create a UserProfile form object" do
      get :edit
      expect(assigns(:profile)).to be_an_instance_of(Forms::UserProfile)
    end

    it "should assign user" do
      get :edit
      expect(assigns(:profile).user).to eq(user)
    end

  end

  describe "update" do

    it "should redirect to public list after update" do
      expect_any_instance_of(Forms::UserProfile).to receive(:update!).and_return(true)
      put :update, user: { username: "test123" }
      expect(response).to redirect_to(public_list_preview_list_path)
    end

    it "should render edit view if update fails" do
      expect_any_instance_of(Forms::UserProfile).to receive(:update!).and_return(false)
      put :update
      expect(response).to render_template("edit")
    end

  end

end
