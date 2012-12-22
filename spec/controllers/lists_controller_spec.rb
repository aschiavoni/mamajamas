require 'spec_helper'

describe ListsController do

  describe "show" do

    let(:user) { create(:user) }

    before(:each) do
      sign_in user
    end

    it "should get list page" do
      get :show
      response.should be_success
    end

  end

end
