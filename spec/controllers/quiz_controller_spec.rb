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

end
