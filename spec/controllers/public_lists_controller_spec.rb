require 'spec_helper'

describe PublicListsController do

  let(:user) { create(:user) }

  before(:all) do
    @list = user.build_list!
  end

  before(:each) do
    @list.update_attributes!(privacy: List::PRIVACY_PUBLIC)
  end

  describe "show" do

    before(:all) { @list.update_attributes!(privacy: List::PRIVACY_PUBLIC) }

    it "returns a 404 if the user is not found" do
      lambda {
        get 'show', slug: "unknownuser"
      }.should raise_error(ActiveRecord::RecordNotFound)
    end

    it "returns a 404 if the list is not found" do
      new_user = create(:user) # user does not have a list

      lambda {
        get 'show', slug: new_user.username
      }.should raise_error(ActionController::RoutingError)
    end

    it "returns a 404 if the list is not public" do
      @list.update_attributes!(privacy: List::PRIVACY_PRIVATE)

      lambda {
        get 'show', slug: user.username
      }.should raise_error(ActionController::RoutingError)
    end

    it "returns http success" do
      get 'show', slug: user.username
      response.should be_success
    end

    it "renders show" do
      get 'show', slug: user.username
      response.should render_template("show")
    end

    it "renders private if the list is auth users only" do
      @list.update_attributes(privacy: List::PRIVACY_REGISTERED)
      get 'show', slug: user.username
      response.should render_template("private")
    end

    it "renders show if list is auth users only but user is authed" do
      @list.update_attributes(privacy: List::PRIVACY_REGISTERED)
      sign_in create(:user)
      get 'show', slug: user.username
      response.should render_template("show")
    end

    it "renders private if the list is auth users only and guest user" do
      @list.update_attributes(privacy: List::PRIVACY_REGISTERED)
      sign_in create(:user, guest: true)
      get 'show', slug: user.username
      response.should render_template("private")
    end

    it "should assign list" do
      get 'show', slug: user.username
      assigns(:list).should == @list
    end

    it "should assign public list view" do
      get 'show', slug: user.username
      assigns(:view).should be_instance_of(PublicListView)
    end

    it "should increment public view count" do
      List.any_instance.should_receive(:increment_public_view_count)
      get 'show', slug: user.username
    end

  end

  describe "preview" do

    before(:each) { sign_in user }

    it "returns a 404 if the list is not found" do
      new_user = create(:user) # user does not have a list
      sign_in new_user

      lambda {
        get 'preview'
      }.should raise_error(ActionController::RoutingError)
    end

    it "returns http success" do
      get 'preview'
      response.should be_success
    end

    it "renders show template" do
      get 'preview'
      response.should render_template("show")
    end

    it "should assign list" do
      get 'preview'
      assigns(:list).should == @list
    end

    it "should assign public list view" do
      get 'preview'
      assigns(:view).should be_instance_of(PublicListView)
    end

  end

  describe 'publish' do

    before(:each) { sign_in user }

    it "should assign list" do
      post 'publish', privacy: List::PRIVACY_PUBLIC
      assigns(:list).should == @list
    end

    it 'should redirect to public list path on publish' do
      post 'publish', privacy: List::PRIVACY_PUBLIC
      response.should redirect_to(public_list_path(user.slug))
    end

    it 'should make list public on publish' do
      post 'publish', privacy: List::PRIVACY_PUBLIC
      assigns(:list).should be_public
    end

    it 'should make list authenticated on publish' do
      post 'publish', privacy: List::PRIVACY_REGISTERED
      assigns(:list).should be_registered_users_only
    end

    it 'should make list registry on publish' do
      post 'publish', privacy: List::PRIVACY_REGISTRY
      assigns(:list).should be_registry
    end

    it 'should redirect to profile path when cancelled' do
      post 'publish', cancel: '1'
      response.should redirect_to list_path
    end

    it 'should send shared list notification' do
      SharedListNotifier.should_receive(:send_shared_list_notification).
        with(an_instance_of(List))
      post 'publish', privacy: List::PRIVACY_PUBLIC
    end

  end

end
