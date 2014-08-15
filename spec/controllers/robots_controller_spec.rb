require 'spec_helper'

describe RobotsController, :type => :controller do

  describe "show" do

    it "should get robots.txt" do
      get :show
      expect(response).to be_success
    end

  end

end

