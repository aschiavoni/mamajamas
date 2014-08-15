require 'spec_helper'

describe ListQuizUpdater, :type => :model do

  before(:all) {
    @user = create(:user)
    @user.build_list!
  }

  it "updates quiz based on quiz answers" do
    [
      feeding = create(:answer, user: @user, question: "feeding"),
      caution = create(:answer, user: @user, question: "caution", answers: [4])
    ]

    expect_any_instance_of(Quiz::Feeding).
      to receive(:process_answers!).with(*feeding.answers)
    expect_any_instance_of(Quiz::Caution).
      to receive(:process_answers!).with(*caution.answers)

    ListQuizUpdater.new(@user).update!
  end

  it "ignores invalid answers" do
    caution = create(:answer, user: @user, question: "caution",
                     answers: %w(whatever))

    expect_any_instance_of(Quiz::Caution).
      to receive(:process_answers!).with(*caution.answers)

    ListQuizUpdater.new(@user).update!
  end

end
