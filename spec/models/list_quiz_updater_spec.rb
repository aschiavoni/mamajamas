require 'spec_helper'

describe ListQuizUpdater do

  let(:user) { create(:user) }

  before(:all) { user.build_list! }

  it "updates quiz based on quiz answers" do
    answers = [
      feeding = create(:answer, user: user, question: "feeding"),
      caution = create(:answer, user: user, question: "caution", answers: [4])
    ]

    Quiz::Feeding.any_instance.
      should_receive(:process_answers!).with(*feeding.answers)
    Quiz::Caution.any_instance.
      should_receive(:process_answers!).with(*caution.answers)

    ListQuizUpdater.new(user).update!
  end

  it "ignores invalid answers" do
    caution = create(:answer, user: user, question: "caution",
                     answers: %w(whatever))

    Quiz::Caution.any_instance.
      should_receive(:process_answers!).with(*caution.answers)

    ListQuizUpdater.new(user).update!
  end

end
