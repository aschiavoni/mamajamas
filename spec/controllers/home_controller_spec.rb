require 'spec_helper'

describe HomeController, :type => :controller do

  describe "index" do

    it "should get home page" do
      get :index
      expect(response).to be_success
    end

  end

end
