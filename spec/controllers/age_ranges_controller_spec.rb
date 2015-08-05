require 'spec_helper'

describe AgeRangesController, :type => :controller do

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
      expect(response).to be_success
    end

    it "assigns age ranges" do
      expect(assigns(:age_ranges)).not_to be_blank
    end
  end

end
