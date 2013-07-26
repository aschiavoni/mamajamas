class Quiz::Answer < ActiveRecord::Base
  attr_accessible :answers, :question, :user_id

  belongs_to :user

  serialize :answers, Array

  def self.save_answer!(user, name, answers)
    Quiz::Answer.create!({
      user_id: user.id,
      question: "feeding",
      answers: answers
    })
  end
end
