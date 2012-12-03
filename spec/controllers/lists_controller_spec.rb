require 'spec_helper'

describe ListsController do

  describe "show" do

    before(:each) do
      # create a few product types and categories
      3.times do 
        create(:product_type)
      end

      # login
      sign_in create(:user)
    end

    it "should get list page" do
      get :show
      response.should be_success
    end

  end

end
