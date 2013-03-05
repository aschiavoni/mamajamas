require 'spec_helper'

describe AgeRangesController do

  before(:all) do
    3.times do
      create(:age_range)
    end
  end

  describe "index" do

    before(:each) do
      sign_in create(:user)
      get 'index', format: :json
    end

    it "returns http success" do
      response.should be_success
    end

    it "assigns age ranges" do
      assigns(:age_ranges).should_not be_blank
    end
  end

end
