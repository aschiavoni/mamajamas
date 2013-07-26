require 'spec_helper'

describe Quiz::Answer do

  let(:user) { create(:user) }

  it "saves multiple answers to the database" do
    lambda {
      Quiz::Answer.save_answer!(user, "feeding", %w(answer1, answer2))
    }.should change(Quiz::Answer, :count).by(1)
  end

end
