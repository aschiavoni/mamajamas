require 'spec_helper'

describe RobotsController do

  describe "show" do

    it "should get robots.txt" do
      get :show
      response.should be_success
    end

  end

end

