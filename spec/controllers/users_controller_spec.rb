require 'spec_helper'

describe UsersController do

  describe "edit" do

    it "should get edit page" do
      get :edit, id: create(:user)
      response.should be_success
    end

  end

end
