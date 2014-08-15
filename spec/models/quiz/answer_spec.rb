require 'spec_helper'

describe Quiz::Answer, :type => :model do

  let(:user) { create(:user) }

  it "saves multiple answers to the database" do
    expect {
      Quiz::Answer.save_answer!(user, "feeding", %w(answer1, answer2))
    }.to change(Quiz::Answer, :count).by(1)
  end

end
