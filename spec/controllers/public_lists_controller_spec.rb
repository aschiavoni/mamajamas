require 'spec_helper'

describe PublicListsController do

  let(:user) { create(:user) }

  before(:all) do
    user.build_list!
    user.list.make_public!
  end

  describe "show" do

    it "returns a 404 if the user is not found" do
      lambda {
        get 'show', username: "unknownuser"
      }.should raise_error(ActionController::RoutingError)
    end

    it "returns a 404 if the list is not found" do
      # clear the list owner
      list = user.list
      list.user_id = nil
      list.save!

      lambda {
        get 'show', username: user.username
      }.should raise_error(ActionController::RoutingError)
    end

    it "returns a 404 if the list is not public" do
      user.list.make_nonpublic!

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
      assigns(:list).should == user.list
    end

  end

end
