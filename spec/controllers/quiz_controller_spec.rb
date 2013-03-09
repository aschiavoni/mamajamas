require 'spec_helper'

describe QuizController do

  let(:user) { create(:user) }

  before(:each) do
    sign_in user
  end

  describe "GET 'show'" do
    it "returns http success" do
      get 'show'
      response.should be_success
    end
  end

end
