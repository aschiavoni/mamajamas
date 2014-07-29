class Quiz::Answer < ActiveRecord::Base
  attr_accessible :answers, :question, :user_id

  belongs_to :user

  serialize :answers, Array

  def self.save_answer!(user, name, answers)
    Quiz::Answer.create!({
      user_id: user.id,
      question: name,
      answers: answers
    })
  end

  def self.most_recent_answers(user_id)
    # TODO: can this query be composed via arel?
    find_by_sql([ %q{
      select quiz_answers.* from quiz_answers
      join (
        select max(created_at) mt, question
        from quiz_answers where user_id = ? group by question
      ) md on (
        md.question = quiz_answers.question and md.mt = quiz_answers.created_at
      )
      where quiz_answers.user_id = ?
      }, user_id, user_id ])
  end
end
