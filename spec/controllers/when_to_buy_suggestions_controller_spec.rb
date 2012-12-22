require 'spec_helper'

describe WhenToBuySuggestionsController do

  before(:all) do
    3.times do
      create(:when_to_buy_suggestion)
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

    it "assigns suggestions" do
      assigns(:suggestions).should_not be_blank
    end
  end

end
