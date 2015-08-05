require 'spec_helper'

describe PublicListsController, :type => :controller do

  before(:all) do
    @user = create(:user)
    @list = @user.build_list!
    @list.update_attributes!(privacy: List::PRIVACY_PUBLIC)
  end

  describe "show" do

    before(:each) do
      @list.update_attributes!(privacy: List::PRIVACY_PUBLIC)
    end

    it "returns a 404 if the user is not found" do
      expect {
        get 'show', slug: "unknownuser"
      }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "returns a 404 if the list is not found" do
      new_user = create(:user) # user does not have a list

      expect {
        get 'show', slug: new_user.username
      }.to raise_error(ActionController::RoutingError)
    end

    it "returns a 404 if the list is not public" do
      @list.update_attributes!(registry: false, privacy: List::PRIVACY_PRIVATE)

      expect {
        get 'show', slug: @user.username
      }.to raise_error(ActionController::RoutingError)
    end

    it "returns http success" do
      get 'show', slug: @user.username
      expect(response).to be_success
    end

    it "renders show" do
      get 'show', slug: @user.username
      expect(response).to render_template("show")
    end

    it "renders private if the list is auth users only" do
      @list.update_attributes(privacy: List::PRIVACY_REGISTERED)
      get 'show', slug: @user.username
      expect(response).to render_template("private")
    end

    it "renders show if list is auth users only but user is authed" do
      @list.update_attributes(privacy: List::PRIVACY_REGISTERED)
      sign_in create(:user)
      get 'show', slug: @user.username
      expect(response).to render_template("show")
    end

    it "renders private if the list is auth users only and guest user" do
      @list.update_attributes(privacy: List::PRIVACY_REGISTERED)
      sign_in create(:user, guest: true)
      get 'show', slug: @user.username
      expect(response).to render_template("private")
    end

    it "should assign list" do
      get 'show', slug: @user.username
      expect(assigns(:list)).to eq(@list)
    end

    it "should assign public list view" do
      get 'show', slug: @user.username
      expect(assigns(:view)).to be_instance_of(PublicListView)
    end

    it "should increment public view count" do
      expect_any_instance_of(List).to receive(:increment_public_view_count)
      get 'show', slug: @user.username
    end

  end

end
