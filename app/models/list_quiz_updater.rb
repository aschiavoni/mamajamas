class ListQuizUpdater # this name sucks
  def initialize(user)
    @user = user
  end

  def update!
    answers = Quiz::Answer.most_recent_answers(user.id)
    answers.each do |answer|
      q = Quiz::Question.by_name(answer.question, user.list)
      begin
        q.process_answers!(*answer.answers)
      rescue ArgumentError
        # just ignore invalid answers
      end
    end
  end

  private

  def user
    @user
  end
end
