require 'spec_helper'

describe QuizController, :type => :controller do

  let(:user) { create(:user, quiz_taken_at: nil) }

  before(:each) do
    sign_in user
  end

  describe "GET 'show'" do

    # [2016-06-05 Sun 11:10] disabled due to to removal of signup
    # it "returns http success" do
    #   get 'show'
    #   expect(response).to be_success
    # end

    # it "assigns countries" do
    #   allow(Country).to receive_messages(:all => [ ["US", "United States"], ["BB", "Barbados"] ])
    #   get 'show'
    #   expect(assigns(:countries)).not_to be_nil
    # end

  end

  describe "PUT 'update'" do

    it "answers question" do
      answers = [ 'Pump', 'Bottle Feed' ]
      expect(Quiz::Answer).to receive(:save_answer!).
        with(user, 'feeding', answers)

      expect(CompleteListWorker).not_to receive(:perform_async)
      put 'update', {
        question: 'Feeding',
        answers: answers
      }
    end

    it "completes list if complete list set" do
      answers = [ 'Pump', 'Bottle Feed' ]
      expect(Quiz::Answer).to receive(:save_answer!).
        with(user, 'feeding', answers)
      expect(CompleteListWorker).to receive(:perform_async).with(user.id)

      put 'update', {
        question: 'Feeding',
        answers: answers,
        complete_list: true
      }
    end

    it "marks the quiz complete" do
      answers = [ 'Pump', 'Bottle Feed' ]
      expect(Quiz::Answer).to receive(:save_answer!).
        with(user, 'feeding', answers)
      expect(CompleteListWorker).to receive(:perform_async).with(user.id)
      expect_any_instance_of(User).to receive(:complete_quiz!)

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

    it "finds the user's first kid" do
      kids = [ double.as_null_object ]
      expect_any_instance_of(User).to receive(:kids).and_return(kids)
      post 'update_kid', kid: kid_params, format: :json
    end

    it "updates the user's first kid" do
      kids = [ Kid.new ]
      expect_any_instance_of(User).to receive(:kids).and_return(kids)
      expect(kids.first).to receive(:update_attributes!).with(kid_params)
      post 'update_kid', kid: kid_params, format: :json
    end

    it "creates the user's first kid" do
      expect_any_instance_of(User).to receive(:kids).and_return([])
      expect(Kid).to receive(:create!).with(kid_params)
      post 'update_kid', kid: kid_params, format: :json
    end

    it "builds the user's list if it does not exist" do
      kids = [ double.as_null_object ]
      expect_any_instance_of(User).to receive(:kids).and_return(kids)
      post 'update_kid', kid: kid_params, format: :json
    end

  end

  describe "PUT 'update' zip code" do

    it "updates zip code and country on the current user" do
      expect_any_instance_of(User).to receive(:update_attributes).
        with({ zip_code: '12345', country_code: 'GB' })
      put 'update_zip_code', zip_code: '12345', country: 'GB', format: :json
    end

    it "sets zip code to nil if blank zip code provided" do
      expect_any_instance_of(User).to receive(:update_attributes).
        with({ zip_code: nil, country_code: 'US' })
      put 'update_zip_code', format: :json
    end

    it "sets country to 'US' if blank country provided" do
      expect_any_instance_of(User).to receive(:update_attributes).
        with({ zip_code: nil, country_code: 'US' })
      put 'update_zip_code', format: :json
    end

    it "updates the zip code and country" do
      put 'update_zip_code',
        zip_code: 'sl41eg',
        country: 'GB',
        format: :json
      expect(response).to be_success
    end

    it "returns errors if it cannot update the zip code and country" do
      put 'update_zip_code',
        zip_code: '11201',
        country: 'United Kingdom',
        format: :json
      expect(JSON.parse(response.body)['errors']).not_to be_empty
    end

  end

end
