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

  describe "PUT 'update'" do

    it "looks for question class" do
      user.stub(:list, stub)
      Quiz::Question.should_receive(:by_name).
        with('Feeding', user.list).
        and_return(stub.as_null_object)

      put 'update', {
        question: 'Feeding'
      }
    end

    it "answers question" do
      answers = [ 'Pump', 'Bottle Feed' ]
      Quiz::Feeding.any_instance.should_receive(:answer).with(*answers)

      put 'update', {
        question: 'Feeding',
        answers: answers
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
      User.any_instance.should_receive(:build_list!)
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
      User.any_instance.should_receive(:update_attributes!).
        with({ zip_code: '12345', country: 'UK' })
      put 'update_zip_code', zip_code: '12345', country: 'UK'
    end

    it "sets zip code to nil if blank zip code provided" do
      User.any_instance.should_receive(:update_attributes!).
        with({ zip_code: nil, country: 'US' })
      put 'update_zip_code'
    end

    it "sets country to 'US' if blank country provided" do
      User.any_instance.should_receive(:update_attributes!).
        with({ zip_code: nil, country: 'US' })
      put 'update_zip_code'
    end

    it "returns ok status if it updates the zip code and country" do
      User.any_instance.should_receive(:update_attributes!).
        with({ zip_code: '12345', country: 'UK' })
      put 'update_zip_code', zip_code: '12345', country: 'UK'
      JSON.parse(response.body)['status'].should == 'ok'
    end

  end

  describe "POST prune list" do

    it "prunes the user's list" do
      user.stub(:list, stub)
      ListPruner.should_receive(:prune!).with(user.list)
      post 'prune_list'
    end

  end

end
