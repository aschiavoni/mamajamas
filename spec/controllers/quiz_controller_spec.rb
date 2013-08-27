require 'spec_helper'

describe QuizController do

  let(:user) { create(:user, quiz_taken_at: nil) }

  before(:each) do
    sign_in user
  end

  describe "GET 'show'" do

    it "returns http success" do
      get 'show'
      response.should be_success
    end

    it "assigns countries" do
      Country.stub(:all => [ ["US", "United States"], ["BB", "Barbados"] ])
      get 'show'
      assigns(:countries).should_not be_nil
    end

  end

  describe "PUT 'update'" do

    it "answers question" do
      answers = [ 'Pump', 'Bottle Feed' ]
      Quiz::Answer.should_receive(:save_answer!).
        with(user, 'feeding', answers)

      CompleteListWorker.should_not_receive(:perform_async)
      put 'update', {
        question: 'Feeding',
        answers: answers
      }
    end

    it "completes list if complete list set" do
      answers = [ 'Pump', 'Bottle Feed' ]
      Quiz::Answer.should_receive(:save_answer!).
        with(user, 'feeding', answers)
      CompleteListWorker.should_receive(:perform_async).with(user.id)

      put 'update', {
        question: 'Feeding',
        answers: answers,
        complete_list: true
      }
    end

  end

  describe "POST 'update' kid" do

    let(:kid_params) do
      {
        'name' => 'Jill'
      }
    end

    before(:each) do
      ListBuilderWorker.should_receive(:perform_async).with(user.id)
    end

    it "finds the user's first kid" do
      kids = [ stub.as_null_object ]
      User.any_instance.should_receive(:kids).and_return(kids)
      post 'update_kid', kid: kid_params
    end

    it "updates the user's first kid" do
      kids = [ Kid.new ]
      User.any_instance.should_receive(:kids).and_return(kids)
      kids.first.should_receive(:update_attributes!).with(kid_params)
      post 'update_kid', kid: kid_params
    end

    it "creates the user's first kid" do
      User.any_instance.should_receive(:kids).and_return([])
      Kid.should_receive(:create!).with(kid_params)
      post 'update_kid', kid: kid_params
    end

    it "builds the user's list if it does not exist" do
      kids = [ stub.as_null_object ]
      User.any_instance.should_receive(:kids).and_return(kids)
      post 'update_kid', kid: kid_params
    end

  end

  describe "PUT 'update' zip code" do

    it "updates zip code and country on the current user" do
      User.any_instance.should_receive(:update_attributes).
        with({ zip_code: '12345', country_code: 'GB' })
      put 'update_zip_code', zip_code: '12345', country: 'GB'
    end

    it "sets zip code to nil if blank zip code provided" do
      User.any_instance.should_receive(:update_attributes).
        with({ zip_code: nil, country_code: 'US' })
      put 'update_zip_code'
    end

    it "sets country to 'US' if blank country provided" do
      User.any_instance.should_receive(:update_attributes).
        with({ zip_code: nil, country_code: 'US' })
      put 'update_zip_code'
    end

    it "updates the zip code and country" do
      put 'update_zip_code',
        zip_code: 'sl41eg',
        country: 'GB',
        format: :json
      response.should be_success
    end

    it "returns errors if it cannot update the zip code and country" do
      put 'update_zip_code',
        zip_code: '11201',
        country: 'United Kingdom',
        format: :json
      JSON.parse(response.body)['errors'].should_not be_empty
    end

    it "marks that the user has taken the quiz" do
      User.any_instance.should_receive(:update_attributes).
        with({ zip_code: 'sl41eg', country_code: 'GB' }).
        and_return(true)
      User.any_instance.should_receive(:complete_quiz!)
      put 'update_zip_code',
        zip_code: 'sl41eg',
        country: 'GB',
        format: :json
    end

  end

end
