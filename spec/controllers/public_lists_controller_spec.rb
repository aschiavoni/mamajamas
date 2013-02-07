require 'spec_helper'

describe PublicListsController do

  let(:user) { create(:user) }

  before(:all) do
    @list = user.build_list!
    @list.make_public!
  end

  describe "show" do

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

  end

end
