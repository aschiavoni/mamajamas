require 'spec_helper'

describe UsersController do

  describe "edit" do

    let(:user) { create(:user) }

    it "should get edit page" do
      get :edit, id: user.id
      response.should be_success
    end

  end

end
