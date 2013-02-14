require 'spec_helper'

describe PublicListsController do

  let(:user) { create(:user) }

  before(:all) do
    @list = user.build_list!
  end

  describe "show" do

    before(:all) { @list.make_public! }

    it "returns a 404 if the user is not found" do
      lambda {
        get 'show', username: "unknownuser"
      }.should raise_error(ActionController::RoutingError)
    end

    it "returns a 404 if the list is not found" do
      new_user = create(:user) # user does not have a list

      lambda {
        get 'show', username: new_user.username
      }.should raise_error(ActionController::RoutingError)
    end

    it "returns a 404 if the list is not public" do
      @list.make_nonpublic!

      lambda {
        get 'show', username: user.username
      }.should raise_error(ActionController::RoutingError)
    end

    it "returns http success" do
      get 'show', username: user.username
      response.should be_success
    end

    it "renders show template" do
      get 'show', username: user.username
      response.should render_template("show")
    end

    it "should assign list" do
      get 'show', username: user.username
      assigns(:list).should == @list
    end

    it "should assign public list view" do
      get 'show', username: user.username
      assigns(:view).should be_instance_of(PublicListView)
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
      post 'publish', publish: '1'
      assigns(:list).should == @list
    end

    it 'should redirect to public list path on publish' do
      post 'publish', publish: '1'
      response.should redirect_to(public_list_path(user.username))
    end

    it 'should make list public on publish' do
      post 'publish', publish: '1'
      assigns(:list).should be_public
    end

    it 'should redirect to profile path when cancelled' do
      post 'publish', cancel: '1'
      response.should redirect_to list_path
    end

  end

end
